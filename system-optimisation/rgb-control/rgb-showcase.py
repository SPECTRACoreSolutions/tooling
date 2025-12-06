#!/usr/bin/env python3
"""
SPECTRA RGB Showcase
Cycles through creative RGB scenes every 10 seconds
"""

import time
import sys

try:
    from openrgb import OpenRGBClient
    from openrgb.utils import RGBColor
except ImportError:
    print("❌ OpenRGB Python SDK not installed!")
    print("   Install with: pip install openrgb-python")
    sys.exit(1)


class RGBShowcase:
    """Showcase different RGB scenes"""
    
    def __init__(self):
        """Connect to OpenRGB"""
        try:
            self.client = OpenRGBClient()
            self.devices = self.client.devices
            print(f"\n✅ Connected! Controlling {len(self.devices)} devices\n")
        except Exception as e:
            print(f"❌ Failed to connect: {e}")
            sys.exit(1)
    
    def set_colour(self, red: int, green: int, blue: int):
        """Set all devices to colour"""
        colour = RGBColor(red, green, blue)
        for device in self.devices:
            try:
                device.set_color(colour)
            except:
                pass
    
    def scene_work_blue(self):
        """Focus Blue - Productivity"""
        print("🔵 SCENE: Work Mode - Focus Blue")
        print("   Purpose: Calm, productive, reduces eye strain")
        print("   RGB(0, 100, 255)\n")
        self.set_colour(0, 100, 255)
    
    def scene_gaming_purple(self):
        """Gaming Purple - Intense"""
        print("🟣 SCENE: Gaming Purple - Intense Energy")
        print("   Purpose: Immersive, energetic, competitive")
        print("   RGB(200, 0, 255)\n")
        self.set_colour(200, 0, 255)
    
    def scene_sunset_orange(self):
        """Sunset Orange - Warm"""
        print("🟠 SCENE: Sunset Orange - Evening Vibes")
        print("   Purpose: Cosy, relaxing, wind-down")
        print("   RGB(255, 140, 0)\n")
        self.set_colour(255, 140, 0)
    
    def scene_forest_green(self):
        """Forest Green - Natural"""
        print("🟢 SCENE: Forest Green - Nature Calm")
        print("   Purpose: Balanced, natural, comfortable")
        print("   RGB(0, 200, 50)\n")
        self.set_colour(0, 200, 50)
    
    def scene_ocean_cyan(self):
        """Ocean Cyan - Cool"""
        print("🩵 SCENE: Ocean Cyan - Cool Breeze")
        print("   Purpose: Fresh, clean, spa-like")
        print("   RGB(0, 255, 200)\n")
        self.set_colour(0, 255, 200)
    
    def scene_sunset_pink(self):
        """Sunset Pink - Dreamy"""
        print("🩷 SCENE: Sunset Pink - Dreamy Aesthetics")
        print("   Purpose: Soft, aesthetic, Instagram-worthy")
        print("   RGB(255, 100, 150)\n")
        self.set_colour(255, 100, 150)
    
    def scene_fire_red(self):
        """Fire Red - Power"""
        print("🔴 SCENE: Fire Red - Maximum Power")
        print("   Purpose: Aggressive, attention, excitement")
        print("   RGB(255, 0, 0)\n")
        self.set_colour(255, 0, 0)
    
    def scene_arctic_white(self):
        """Arctic White - Pure"""
        print("⚪ SCENE: Arctic White - Pure Clean")
        print("   Purpose: Crisp, clean, professional")
        print("   RGB(255, 255, 255)\n")
        self.set_colour(255, 255, 255)
    
    def scene_neon_lime(self):
        """Neon Lime - Electric"""
        print("🟢 SCENE: Neon Lime - Electric Energy")
        print("   Purpose: High-energy, cyberpunk, clubbing")
        print("   RGB(150, 255, 0)\n")
        self.set_colour(150, 255, 0)
    
    def scene_royal_purple(self):
        """Royal Purple - Luxury"""
        print("🟣 SCENE: Royal Purple - Premium Luxury")
        print("   Purpose: Elegant, sophisticated, premium")
        print("   RGB(128, 0, 200)\n")
        self.set_colour(128, 0, 200)
    
    def scene_sunrise_gold(self):
        """Sunrise Gold - Morning"""
        print("🟡 SCENE: Sunrise Gold - Morning Energy")
        print("   Purpose: Energising, optimistic, morning coffee")
        print("   RGB(255, 200, 0)\n")
        self.set_colour(255, 200, 0)
    
    def scene_midnight_blue(self):
        """Midnight Blue - Deep Focus"""
        print("🔵 SCENE: Midnight Blue - Deep Focus")
        print("   Purpose: Concentration, late-night work, deep thinking")
        print("   RGB(0, 50, 150)\n")
        self.set_colour(0, 50, 150)
    
    def scene_cherry_blossom(self):
        """Cherry Blossom - Soft"""
        print("🌸 SCENE: Cherry Blossom - Soft Pink")
        print("   Purpose: Gentle, romantic, calming")
        print("   RGB(255, 150, 200)\n")
        self.set_colour(255, 150, 200)
    
    def scene_toxic_green(self):
        """Toxic Green - Cyberpunk"""
        print("🟢 SCENE: Toxic Green - Matrix/Cyberpunk")
        print("   Purpose: Hacker aesthetic, terminal vibes, Matrix")
        print("   RGB(0, 255, 50)\n")
        self.set_colour(0, 255, 50)
    
    def scene_blood_red(self):
        """Blood Red - Alert"""
        print("🔴 SCENE: Blood Red - High Alert")
        print("   Purpose: Warning, critical status, urgency")
        print("   RGB(200, 0, 0)\n")
        self.set_colour(200, 0, 0)
    
    def scene_lavender(self):
        """Lavender - Calm"""
        print("🟣 SCENE: Lavender - Peaceful Calm")
        print("   Purpose: Meditation, relaxation, zen")
        print("   RGB(180, 100, 255)\n")
        self.set_colour(180, 100, 255)
    
    def scene_amber(self):
        """Amber - Warmth"""
        print("🟠 SCENE: Amber - Cosy Warmth")
        print("   Purpose: Fireplace vibes, comfort, autumn")
        print("   RGB(255, 180, 50)\n")
        self.set_colour(255, 180, 50)
    
    def scene_teal(self):
        """Teal - Balance"""
        print("🩵 SCENE: Teal - Balanced Energy")
        print("   Purpose: Hybrid focus, creative work, balance")
        print("   RGB(0, 200, 180)\n")
        self.set_colour(0, 200, 180)
    
    def scene_hot_pink(self):
        """Hot Pink - Party"""
        print("🩷 SCENE: Hot Pink - Party Mode")
        print("   Purpose: Fun, energetic, celebratory")
        print("   RGB(255, 0, 150)\n")
        self.set_colour(255, 0, 150)
    
    def scene_electric_blue(self):
        """Electric Blue - Power"""
        print("⚡ SCENE: Electric Blue - High Performance")
        print("   Purpose: Power mode, maximum productivity")
        print("   RGB(0, 150, 255)\n")
        self.set_colour(0, 150, 255)
    
    def scene_dim_red(self):
        """Dim Red - Sleep"""
        print("🔴 SCENE: Dim Red - Sleep Mode")
        print("   Purpose: Night-friendly, preserves night vision")
        print("   RGB(100, 0, 0)\n")
        self.set_colour(100, 0, 0)
    
    def run_showcase(self, interval: int = 10):
        """Run showcase cycling through all scenes"""
        print("\n╔════════════════════════════════════════════════════════════════════════════╗")
        print("║              🎨 SPECTRA RGB SHOWCASE - 20 SCENES! 🎨                      ║")
        print("╚════════════════════════════════════════════════════════════════════════════╝\n")
        
        print(f"🎭 Showcasing 20 different RGB scenes")
        print(f"⏱️  Each scene displays for {interval} seconds")
        print(f"🎨 Watch your entire setup transform!\n")
        print("   Press Ctrl+C to stop...\n")
        print("═══════════════════════════════════════════════════════════════════════════\n")
        
        scenes = [
            self.scene_work_blue,
            self.scene_gaming_purple,
            self.scene_sunset_orange,
            self.scene_forest_green,
            self.scene_ocean_cyan,
            self.scene_sunset_pink,
            self.scene_fire_red,
            self.scene_arctic_white,
            self.scene_neon_lime,
            self.scene_royal_purple,
            self.scene_sunrise_gold,
            self.scene_midnight_blue,
            self.scene_cherry_blossom,
            self.scene_toxic_green,
            self.scene_blood_red,
            self.scene_lavender,
            self.scene_amber,
            self.scene_teal,
            self.scene_hot_pink,
            self.scene_electric_blue,
        ]
        
        try:
            scene_num = 1
            while True:
                for scene in scenes:
                    print(f"Scene {scene_num}/20:")
                    scene()
                    time.sleep(interval)
                    scene_num += 1
                
                # Loop back
                print("\n🔄 Starting showcase again...\n")
                scene_num = 1
        
        except KeyboardInterrupt:
            print("\n\n🎨 Showcase stopped!")
            print("   Setting back to Work Mode (blue)...\n")
            self.scene_work_blue()
            print("✅ Returned to blue. Enjoy your RGB! 🔵\n")


def main():
    """Main entry point"""
    showcase = RGBShowcase()
    showcase.run_showcase(interval=10)


if __name__ == "__main__":
    main()




