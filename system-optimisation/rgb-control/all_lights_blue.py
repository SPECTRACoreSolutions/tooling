#!/usr/bin/env python3
"""
SPECTRA All Lights Blue - Unified Lighting Control
Controls OpenRGB, Philips Hue, and Nanoleaf to set everything blue

Usage:
    python all_lights_blue.py
    python all_lights_blue.py --color 0 100 255  (custom blue)
"""

import sys
import os
import json
from pathlib import Path

# Try to import required libraries
try:
    from openrgb import OpenRGBClient
    from openrgb.utils import RGBColor
    OPENRGB_AVAILABLE = True
except ImportError:
    OPENRGB_AVAILABLE = False
    print("⚠️  OpenRGB Python SDK not installed (optional)")

try:
    import httpx
    HTTPX_AVAILABLE = True
except ImportError:
    HTTPX_AVAILABLE = False
    print("⚠️  httpx not installed (required for Hue/Nanoleaf)")


class UnifiedLightController:
    """Unified controller for all lighting systems"""
    
    def __init__(self):
        self.config_file = Path(__file__).parent / "lighting-config.json"
        self.config = self._load_config()
        
        # OpenRGB
        self.openrgb_client = None
        
        # Hue
        self.hue_bridge_ip = self.config.get("hue_bridge_ip")
        self.hue_username = self.config.get("hue_username")
        
        # Nanoleaf
        self.nanoleaf_ip = self.config.get("nanoleaf_ip")
        self.nanoleaf_token = self.config.get("nanoleaf_token")
        
    def _load_config(self):
        """Load configuration from JSON file or create default"""
        if self.config_file.exists():
            try:
                with open(self.config_file, "r") as f:
                    return json.load(f)
            except Exception as e:
                print(f"⚠️  Error loading config: {e}")
                return {}
        else:
            # Create default config template
            default_config = {
                "hue_bridge_ip": "",
                "hue_username": "",
                "nanoleaf_ip": "",
                "nanoleaf_token": "",
                "openrgb_host": "127.0.0.1",
                "openrgb_port": 6742
            }
            self._save_config(default_config)
            return default_config
    
    def _save_config(self, config):
        """Save configuration to JSON file"""
        try:
            with open(self.config_file, "w") as f:
                json.dump(config, f, indent=2)
        except Exception as e:
            print(f"⚠️  Error saving config: {e}")
    
    def set_all_blue(self, red=0, green=100, blue=255):
        """Set all lights to blue"""
        print(f"\n🔵 Turning all lights blue: RGB({red}, {green}, {blue})\n")
        
        results = {
            "openrgb": False,
            "hue": False,
            "nanoleaf": False
        }
        
        # 1. OpenRGB (PC RGB)
        if OPENRGB_AVAILABLE:
            results["openrgb"] = self._set_openrgb_blue(red, green, blue)
        else:
            print("⏭️  Skipping OpenRGB (SDK not installed)")
        
        # 2. Philips Hue
        if HTTPX_AVAILABLE and self.hue_bridge_ip and self.hue_username:
            results["hue"] = self._set_hue_blue(red, green, blue)
        else:
            print("⏭️  Skipping Hue (not configured)")
            if not HTTPX_AVAILABLE:
                print("   Install: pip install httpx")
            elif not self.hue_bridge_ip:
                print("   Configure: hue_bridge_ip in lighting-config.json")
        
        # 3. Nanoleaf
        if HTTPX_AVAILABLE and self.nanoleaf_ip and self.nanoleaf_token:
            results["nanoleaf"] = self._set_nanoleaf_blue(red, green, blue)
        else:
            print("⏭️  Skipping Nanoleaf (not configured)")
            if not HTTPX_AVAILABLE:
                print("   Install: pip install httpx")
            elif not self.nanoleaf_ip:
                print("   Configure: nanoleaf_ip and nanoleaf_token in lighting-config.json")
        
        # Summary
        print(f"\n{'='*60}")
        print("📊 Results Summary:")
        print(f"{'='*60}")
        print(f"  OpenRGB:  {'✅ Success' if results['openrgb'] else '❌ Failed/Skipped'}")
        print(f"  Hue:      {'✅ Success' if results['hue'] else '❌ Failed/Skipped'}")
        print(f"  Nanoleaf: {'✅ Success' if results['nanoleaf'] else '❌ Failed/Skipped'}")
        print(f"{'='*60}\n")
        
        if any(results.values()):
            print("🎉 At least one lighting system is now blue!\n")
        else:
            print("⚠️  No lighting systems were configured. See instructions above.\n")
    
    def _set_openrgb_blue(self, red, green, blue):
        """Set OpenRGB devices to blue"""
        try:
            print("🎮 Controlling OpenRGB (PC RGB)...")
            
            host = self.config.get("openrgb_host", "127.0.0.1")
            port = self.config.get("openrgb_port", 6742)
            
            client = OpenRGBClient(host, port)
            colour = RGBColor(red, green, blue)
            
            device_count = 0
            for device in client.devices:
                device.set_color(colour)
                device_count += 1
            
            print(f"   ✅ Set {device_count} device(s) to blue")
            return True
            
        except Exception as e:
            print(f"   ❌ OpenRGB error: {e}")
            print("   💡 Make sure OpenRGB is running with SDK Server enabled")
            return False
    
    def _set_hue_blue(self, red, green, blue):
        """Set Philips Hue lights to blue"""
        try:
            print("💡 Controlling Philips Hue...")
            
            # Convert RGB to Hue XY colour space
            xy = self._rgb_to_hue_xy(red, green, blue)
            
            # Get all lights
            url = f"http://{self.hue_bridge_ip}/api/{self.hue_username}/lights"
            response = httpx.get(url, timeout=5.0)
            response.raise_for_status()
            lights = response.json()
            
            # Set each light to blue
            light_count = 0
            for light_id in lights.keys():
                light_url = f"http://{self.hue_bridge_ip}/api/{self.hue_username}/lights/{light_id}/state"
                
                # Convert RGB to brightness (use blue channel as reference)
                brightness = int((blue / 255) * 254)
                
                payload = {
                    "on": True,
                    "xy": xy,
                    "bri": brightness,
                    "sat": 254  # Full saturation for vibrant blue
                }
                
                result = httpx.put(light_url, json=payload, timeout=5.0)
                if result.status_code == 200:
                    light_count += 1
            
            print(f"   ✅ Set {light_count} Hue light(s) to blue")
            return True
            
        except Exception as e:
            print(f"   ❌ Hue error: {e}")
            return False
    
    def _set_nanoleaf_blue(self, red, green, blue):
        """Set Nanoleaf panels to blue"""
        try:
            print("✨ Controlling Nanoleaf...")
            
            # Set static effect with blue colour
            url = f"http://{self.nanoleaf_ip}:16021/api/v1/{self.nanoleaf_token}/effects"
            
            payload = {
                "write": {
                    "command": "display",
                    "animType": "static",
                    "animData": "1 1 1 0 1 100 0 100 255 0 100",
                    "loop": False
                }
            }
            
            response = httpx.put(url, json=payload, timeout=5.0)
            response.raise_for_status()
            
            print(f"   ✅ Set Nanoleaf panels to blue")
            return True
            
        except Exception as e:
            print(f"   ❌ Nanoleaf error: {e}")
            return False
    
    def _rgb_to_hue_xy(self, red, green, blue):
        """Convert RGB to Philips Hue XY colour space"""
        # Normalize RGB values
        r = red / 255.0
        g = green / 255.0
        b = blue / 255.0
        
        # Apply gamma correction
        r = ((r + 0.055) / 1.055) ** 2.4 if r > 0.04045 else r / 12.92
        g = ((g + 0.055) / 1.055) ** 2.4 if g > 0.04045 else g / 12.92
        b = ((b + 0.055) / 1.055) ** 2.4 if b > 0.04045 else b / 12.92
        
        # Convert to XYZ
        X = r * 0.4124 + g * 0.3576 + b * 0.1805
        Y = r * 0.2126 + g * 0.7152 + b * 0.0722
        Z = r * 0.0193 + g * 0.1192 + b * 0.9505
        
        # Normalize to 0-1 range
        x = X / (X + Y + Z)
        y = Y / (X + Y + Z)
        
        return [round(x, 4), round(y, 4)]


def show_help():
    """Show usage information"""
    print("""
╔════════════════════════════════════════════════════════════════════════════╗
║              SPECTRA All Lights Blue - Unified Lighting Control            ║
╚════════════════════════════════════════════════════════════════════════════╝

Usage:
    python all_lights_blue.py
    python all_lights_blue.py --color <red> <green> <blue>
    python all_lights_blue.py --help

Examples:
    python all_lights_blue.py                    # Default blue (0, 100, 255)
    python all_lights_blue.py --color 0 150 255  # Lighter blue
    python all_lights_blue.py --color 30 144 255 # Dodger blue

Configuration:
    Edit lighting-config.json to configure:
    - Hue Bridge IP and username
    - Nanoleaf IP and auth token
    
    File location: Core/tooling/system-optimisation/rgb-control/lighting-config.json

Requirements:
    - OpenRGB: pip install openrgb-python (for PC RGB)
    - HTTP requests: pip install httpx (for Hue/Nanoleaf)
    
""")


def main():
    """Main entry point"""
    # Parse arguments
    if len(sys.argv) > 1:
        if sys.argv[1] in ["--help", "-h", "help"]:
            show_help()
            return
        elif sys.argv[1] == "--color" and len(sys.argv) == 5:
            try:
                red = int(sys.argv[2])
                green = int(sys.argv[3])
                blue = int(sys.argv[4])
                
                if not all(0 <= x <= 255 for x in [red, green, blue]):
                    print("❌ RGB values must be between 0 and 255")
                    return
            except ValueError:
                print("❌ Invalid RGB values. Must be integers.")
                return
        else:
            print("❌ Invalid arguments. Use --help for usage.")
            return
    else:
        # Default blue
        red, green, blue = 0, 100, 255
    
    # Create controller and set lights to blue
    controller = UnifiedLightController()
    controller.set_all_blue(red, green, blue)


if __name__ == "__main__":
    main()




