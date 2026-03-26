#!/usr/bin/env python3
"""
SPECTRA RGB Control Center
Interactive menu to control all 806 RGB LEDs
"""

import os
import sys

try:
    from openrgb import OpenRGBClient
    from openrgb.utils import RGBColor
except ImportError:
    print("❌ OpenRGB Python SDK not installed!")
    print("   Install with: pip install openrgb-python")
    sys.exit(1)


class SPECTRAControlCenter:
    """Interactive RGB control center"""

    def __init__(self):
        """Connect to OpenRGB"""
        try:
            self.client = OpenRGBClient()
            self.devices = self.client.devices
        except Exception as e:
            print(f"❌ Failed to connect to OpenRGB: {e}")
            print("   Make sure OpenRGB is running with SDK Server enabled!")
            sys.exit(1)

    def show_banner(self):
        """Show SPECTRA banner"""
        os.system("cls" if os.name == "nt" else "clear")
        print(
            "\n╔════════════════════════════════════════════════════════════════════════════╗"
        )
        print(
            "║                    SPECTRA RGB CONTROL CENTER                              ║"
        )
        print(
            "╚════════════════════════════════════════════════════════════════════════════╝\n"
        )

        total_leds = sum(len(device.leds) for device in self.devices)
        print(
            f"🎨 Controlling {len(self.devices)} devices with {total_leds} RGB LEDs\n"
        )

    def show_menu(self):
        """Show main menu"""
        print(
            "═══════════════════════════════════════════════════════════════════════════"
        )
        print(
            "                              QUICK MODES                                  "
        )
        print(
            "═══════════════════════════════════════════════════════════════════════════\n"
        )

        print("  1. 🔵 Work Mode       - Focus Blue (productive, calm)")
        print("  2. 🌈 Gaming Mode     - Rainbow Wave (energetic, immersive)")
        print("  3. 🟠 Relax Mode      - Warm Orange (cosy, evening)")
        print("  4. 🔴 Sleep Mode      - Dim Red (night-friendly)")
        print("  5. ⚫ Off             - Turn off all RGB\n")

        print(
            "═══════════════════════════════════════════════════════════════════════════"
        )
        print(
            "                           ADVANCED CONTROLS                               "
        )
        print(
            "═══════════════════════════════════════════════════════════════════════════\n"
        )

        print("  6. 🎨 Custom Colour   - Set any RGB value")
        print("  7. 💨 Breathe Effect  - Breathing animation")
        print("  8. ⚡ Flash           - Flash for notifications")
        print("  9. 🌡️  Temp Monitor   - CPU temperature reactive")
        print(" 10. 📊 Device Control  - Control individual devices\n")

        print(
            "═══════════════════════════════════════════════════════════════════════════"
        )
        print(
            "                              SYSTEM                                       "
        )
        print(
            "═══════════════════════════════════════════════════════════════════════════\n"
        )

        print(" 11. 📋 List Devices    - Show all RGB devices")
        print(" 12. ℹ️  Help           - Show command reference")
        print("  0. 🚪 Exit           - Close control center\n")

        print(
            "═══════════════════════════════════════════════════════════════════════════\n"
        )

    def set_all_colour(self, red: int, green: int, blue: int, description: str = ""):
        """Set all devices to colour"""
        colour = RGBColor(red, green, blue)

        if description:
            print(f"\n🎨 Applying: {description}")
        print(f"   RGB({red}, {green}, {blue}) → {len(self.devices)} devices...")

        for device in self.devices:
            try:
                device.set_color(colour)
            except Exception as e:
                print(f"   ⚠️  {device.name}: {e}")

        print("   ✅ Applied to all devices!\n")

    def work_mode(self):
        """Focus blue"""
        self.set_all_colour(0, 100, 255, "Work Mode - Focus Blue 🔵")

    def gaming_mode(self):
        """Rainbow wave"""
        print("\n🎮 Gaming Mode - Rainbow Wave 🌈")
        print("   Setting rainbow effects...\n")

        for device in self.devices:
            try:
                # Try rainbow mode
                if hasattr(device, "set_mode"):
                    modes = [m for m in device.modes if "rainbow" in m.name.lower()]
                    if modes:
                        device.set_mode(modes[0])
                        print(f"   ✅ {device.name}: Rainbow")
                    else:
                        device.set_color(RGBColor(255, 0, 255))
                        print(f"   ✅ {device.name}: Magenta fallback")
            except Exception as e:
                print(f"   ⚠️  {device.name}: {e}")

        print("\n   🎮 Gaming mode activated!\n")

    def relax_mode(self):
        """Warm orange"""
        self.set_all_colour(255, 150, 50, "Relax Mode - Warm Orange 🟠")

    def sleep_mode(self):
        """Dim red"""
        self.set_all_colour(100, 0, 0, "Sleep Mode - Dim Red 🔴")

    def off(self):
        """Turn off"""
        self.set_all_colour(0, 0, 0, "Off - All RGB Disabled ⚫")

    def custom_colour(self):
        """Custom colour input"""
        print("\n🎨 Custom Colour Mode\n")

        try:
            red = int(input("Red (0-255): "))
            green = int(input("Green (0-255): "))
            blue = int(input("Blue (0-255): "))

            if 0 <= red <= 255 and 0 <= green <= 255 and 0 <= blue <= 255:
                self.set_all_colour(red, green, blue, "Custom Colour")
            else:
                print("\n❌ Invalid values. Must be 0-255.\n")
        except ValueError:
            print("\n❌ Invalid input. Numbers only.\n")

    def breathe_effect(self):
        """Breathing animation"""
        import time

        print("\n💨 Breathe Effect (10 seconds)")
        print("   Press Ctrl+C to stop...\n")

        try:
            start = time.time()
            while time.time() - start < 10:
                # Fade in
                for brightness in range(0, 256, 15):
                    r = (0 * brightness) // 255
                    g = (100 * brightness) // 255
                    b = (255 * brightness) // 255
                    for device in self.devices:
                        device.set_color(RGBColor(r, g, b))
                    time.sleep(0.03)

                # Fade out
                for brightness in range(255, -1, -15):
                    r = (0 * brightness) // 255
                    g = (100 * brightness) // 255
                    b = (255 * brightness) // 255
                    for device in self.devices:
                        device.set_color(RGBColor(r, g, b))
                    time.sleep(0.03)

            print("   ✅ Breathe complete!\n")

        except KeyboardInterrupt:
            print("\n   ⏸️  Stopped.\n")

    def flash_effect(self):
        """Flash notification"""
        import time

        print("\n⚡ Flash Effect (red, 3 times)\n")

        colour = RGBColor(255, 0, 0)
        off = RGBColor(0, 0, 0)

        for i in range(3):
            for device in self.devices:
                device.set_color(colour)
            time.sleep(0.2)

            for device in self.devices:
                device.set_color(off)
            time.sleep(0.2)

        print("   ✅ Flash complete!\n")

    def temp_monitor(self):
        """Launch temperature monitor"""
        print("\n🌡️  Launching CPU temperature monitor...")
        print("   Opening in separate window...\n")

        os.system("start python cpu_temp_rgb.py")
        input("Press Enter to return to menu...")

    def device_control(self):
        """Control individual devices"""
        print(
            "\n╔════════════════════════════════════════════════════════════════════════════╗"
        )
        print(
            "║                        INDIVIDUAL DEVICE CONTROL                           ║"
        )
        print(
            "╚════════════════════════════════════════════════════════════════════════════╝\n"
        )

        print("Your Devices:\n")
        for idx, device in enumerate(self.devices, 1):
            led_count = len(device.leds)
            print(f"  {idx}. {device.name}")
            print(f"     LEDs: {led_count}, Zones: {len(device.zones)}")

        print("\n💡 Coming soon: Per-device control!")
        print("   For now, use main menu to control all devices.\n")

        input("Press Enter to return to menu...")

    def list_devices(self):
        """List all devices with details"""
        print(
            "\n╔════════════════════════════════════════════════════════════════════════════╗"
        )
        print(
            "║                          YOUR RGB DEVICES                                  ║"
        )
        print(
            "╚════════════════════════════════════════════════════════════════════════════╝\n"
        )

        total_leds = 0
        for idx, device in enumerate(self.devices, 1):
            led_count = len(device.leds)
            total_leds += led_count

            print(f"{idx}. {device.name}")
            print(f"   Type: {device.type}")
            print(f"   LEDs: {led_count}")
            print(f"   Zones: {len(device.zones)}")
            print(f"   Modes: {len(device.modes)}")
            print()

        print(
            "═══════════════════════════════════════════════════════════════════════════"
        )
        print(f"Total: {len(self.devices)} devices, {total_leds} RGB LEDs")
        print(
            "═══════════════════════════════════════════════════════════════════════════\n"
        )

        input("Press Enter to return to menu...")

    def show_help(self):
        """Show help"""
        print(
            "\n╔════════════════════════════════════════════════════════════════════════════╗"
        )
        print(
            "║                              HELP                                          ║"
        )
        print(
            "╚════════════════════════════════════════════════════════════════════════════╝\n"
        )

        print("Command Line Usage:")
        print("  python rgb_control.py work      # Quick work mode")
        print("  python rgb_control.py gaming    # Quick gaming mode")
        print("  python rgb_control.py off       # Quick off\n")

        print("Scripts:")
        print("  control_center.py   - This interactive menu")
        print("  rgb_control.py      - Command-line control")
        print("  cpu_temp_rgb.py     - Temperature monitor\n")

        print("Documentation:")
        print("  README.md           - Full documentation")
        print("  QUICK-START.md      - Quick reference")
        print("  YOUR-RGB-DEVICES.md - Your device list\n")

        input("Press Enter to return to menu...")

    def run(self):
        """Main control loop"""
        while True:
            self.show_banner()
            self.show_menu()

            try:
                choice = input("Select option (0-12): ").strip()

                if choice == "1":
                    self.work_mode()
                elif choice == "2":
                    self.gaming_mode()
                elif choice == "3":
                    self.relax_mode()
                elif choice == "4":
                    self.sleep_mode()
                elif choice == "5":
                    self.off()
                elif choice == "6":
                    self.custom_colour()
                elif choice == "7":
                    self.breathe_effect()
                elif choice == "8":
                    self.flash_effect()
                elif choice == "9":
                    self.temp_monitor()
                elif choice == "10":
                    self.device_control()
                elif choice == "11":
                    self.list_devices()
                elif choice == "12":
                    self.show_help()
                elif choice == "0":
                    print("\n👋 Goodbye!\n")
                    break
                else:
                    print("\n❌ Invalid choice. Try again.\n")

                if choice not in [
                    "9",
                    "10",
                    "11",
                    "12",
                ]:  # Don't pause for submenu items
                    input("Press Enter to continue...")

            except KeyboardInterrupt:
                print("\n\n👋 Goodbye!\n")
                break
            except Exception as e:
                print(f"\n❌ Error: {e}\n")
                input("Press Enter to continue...")


def main():
    """Main entry point"""
    center = SPECTRAControlCenter()
    center.run()


if __name__ == "__main__":
    main()









