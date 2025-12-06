#!/usr/bin/env python3
"""
SPECTRA RGB Control - Advanced Python Controller
Controls OpenRGB via SDK for complete RGB automation
"""

import sys
import time

try:
    from openrgb import OpenRGBClient
    from openrgb.utils import DeviceType, RGBColor
except ImportError:
    print("❌ OpenRGB Python SDK not installed!")
    print("   Install with: pip install openrgb-python")
    print("   Then run this script again.")
    sys.exit(1)


class SPECTRARGBController:
    """SPECTRA-grade RGB controller for OpenRGB"""

    def __init__(self, host="127.0.0.1", port=6742):
        """Connect to OpenRGB SDK server"""
        try:
            self.client = OpenRGBClient(host, port)
            print(f"✅ Connected to OpenRGB at {host}:{port}")
            self._discover_devices()
        except Exception as e:
            print(f"❌ Failed to connect to OpenRGB: {e}")
            print("   Make sure OpenRGB is running with SDK Server enabled!")
            sys.exit(1)

    def _discover_devices(self):
        """Discover all RGB devices"""
        self.devices = self.client.devices
        print(f"\n📍 Found {len(self.devices)} RGB device(s):\n")
        for idx, device in enumerate(self.devices):
            print(f"   {idx + 1}. {device.name}")
            print(f"      Type: {device.type}")
            print(f"      Zones: {len(device.zones)}")
            print()

    def set_colour(self, red: int, green: int, blue: int, description: str = ""):
        """Set all devices to specific colour"""
        colour = RGBColor(red, green, blue)
        print(f"🎨 Setting all devices to RGB({red}, {green}, {blue})")
        if description:
            print(f"   Mode: {description}")

        for device in self.devices:
            try:
                device.set_color(colour)
            except Exception as e:
                print(f"   ⚠️  Failed to set {device.name}: {e}")

        print("   ✅ Colour applied!\n")

    def work_mode(self):
        """Focus blue - cool, calming, productive"""
        self.set_colour(0, 100, 255, "Work Mode - Focus Blue")

    def gaming_mode(self):
        """Rainbow wave effect"""
        print("🎮 Gaming Mode - Rainbow Wave")
        print("   Setting rainbow effect...")

        for device in self.devices:
            try:
                # Try to set rainbow effect if supported
                if hasattr(device, "set_mode"):
                    modes = [m for m in device.modes if "rainbow" in m.name.lower()]
                    if modes:
                        device.set_mode(modes[0])
                        print(f"   ✅ {device.name}: Rainbow effect")
                    else:
                        # Fallback to cycling colours manually
                        device.set_color(RGBColor(255, 0, 255))
                        print(f"   ✅ {device.name}: Magenta (rainbow not available)")
            except Exception as e:
                print(f"   ⚠️  {device.name}: {e}")

        print("   🎮 Gaming mode activated!\n")

    def relax_mode(self):
        """Warm orange - cosy, comfortable"""
        self.set_colour(255, 150, 50, "Relax Mode - Warm Orange")

    def sleep_mode(self):
        """Dim red - night-friendly, low blue light"""
        self.set_colour(100, 0, 0, "Sleep Mode - Dim Red")

    def off(self):
        """Turn off all RGB"""
        self.set_colour(0, 0, 0, "Off - All RGB Disabled")

    def breathe_effect(self, red: int, green: int, blue: int, duration: int = 10):
        """Breathing effect for specified duration"""
        print(f"💨 Breathing effect RGB({red}, {green}, {blue}) for {duration}s")

        start_time = time.time()
        while time.time() - start_time < duration:
            # Fade in
            for brightness in range(0, 256, 10):
                r = (red * brightness) // 255
                g = (green * brightness) // 255
                b = (blue * brightness) // 255
                for device in self.devices:
                    device.set_color(RGBColor(r, g, b))
                time.sleep(0.05)

            # Fade out
            for brightness in range(255, -1, -10):
                r = (red * brightness) // 255
                g = (green * brightness) // 255
                b = (blue * brightness) // 255
                for device in self.devices:
                    device.set_color(RGBColor(r, g, b))
                time.sleep(0.05)

        print("   ✅ Breathe effect complete!\n")

    def flash(self, red: int, green: int, blue: int, times: int = 3):
        """Flash effect - useful for notifications"""
        print(f"⚡ Flashing RGB({red}, {green}, {blue}) {times} times")

        colour = RGBColor(red, green, blue)
        off = RGBColor(0, 0, 0)

        for _ in range(times):
            for device in self.devices:
                device.set_color(colour)
            time.sleep(0.2)

            for device in self.devices:
                device.set_color(off)
            time.sleep(0.2)

        print("   ✅ Flash complete!\n")

    def close(self):
        """Close connection"""
        if self.client:
            print("👋 Disconnecting from OpenRGB...")


def show_help():
    """Show usage information"""
    print("""
╔════════════════════════════════════════════════════════════════════════════╗
║                  SPECTRA RGB Control - Python Edition                      ║
╚════════════════════════════════════════════════════════════════════════════╝

Usage:
    python rgb-control.py <mode>

Modes:
    work        - Focus Blue (0, 100, 255)
    gaming      - Rainbow Wave effect
    relax       - Warm Orange (255, 150, 50)
    sleep       - Dim Red (100, 0, 0)
    off         - Turn off all RGB
    
    breathe     - Breathing effect (blue)
    flash       - Flash effect (red) - good for notifications
    
    list        - Show all detected RGB devices
    help        - Show this help message

Examples:
    python rgb-control.py work
    python rgb-control.py gaming
    python rgb-control.py off

Advanced:
    Edit this script to create custom colour profiles!
    
""")


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        show_help()
        return

    mode = sys.argv[1].lower()

    if mode == "help":
        show_help()
        return

    # Connect to OpenRGB
    controller = SPECTRARGBController()

    try:
        if mode == "work":
            controller.work_mode()
        elif mode == "gaming":
            controller.gaming_mode()
        elif mode == "relax":
            controller.relax_mode()
        elif mode == "sleep":
            controller.sleep_mode()
        elif mode == "off":
            controller.off()
        elif mode == "breathe":
            controller.breathe_effect(0, 100, 255)
        elif mode == "flash":
            controller.flash(255, 0, 0)
        elif mode == "list":
            pass  # Already listed during connection
        else:
            print(f"❌ Unknown mode: {mode}")
            print("   Use 'help' to see available modes.")

    finally:
        controller.close()


if __name__ == "__main__":
    main()



