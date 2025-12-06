#!/usr/bin/env python3
"""
SPECTRA RGB - CPU Temperature Reactive Lighting
Changes RGB colour based on CPU temperature
"""

import sys
import time
from typing import Optional

try:
    from openrgb import OpenRGBClient
    from openrgb.utils import RGBColor
except ImportError:
    print("❌ OpenRGB Python SDK not installed!")
    print("   Install with: pip install openrgb-python")
    sys.exit(1)

try:
    import psutil
except ImportError:
    print("❌ psutil not installed!")
    print("   Install with: pip install psutil")
    sys.exit(1)


class CPUTemperatureRGB:
    """CPU temperature-reactive RGB controller"""

    def __init__(self):
        """Initialize RGB controller"""
        try:
            self.client = OpenRGBClient()
            self.devices = self.client.devices
            print(f"✅ Connected to OpenRGB ({len(self.devices)} devices)")
        except Exception as e:
            print(f"❌ Failed to connect to OpenRGB: {e}")
            sys.exit(1)

    def get_cpu_temp(self) -> Optional[float]:
        """Get CPU temperature in Celsius"""
        try:
            temps = psutil.sensors_temperatures()

            # Try different sensor names
            for name in ["coretemp", "k10temp", "zenpower", "cpu_thermal"]:
                if name in temps:
                    # Get the highest temperature (usually Package temp)
                    return max([t.current for t in temps[name]])

            # Fallback: get any temperature sensor
            if temps:
                first_sensor = list(temps.values())[0]
                return max([t.current for t in first_sensor])

            return None

        except Exception as e:
            print(f"⚠️  Failed to read temperature: {e}")
            return None

    def temp_to_colour(self, temp: float) -> RGBColor:
        """
        Convert temperature to colour:
        < 50°C  = Blue (cool)
        50-60°C = Cyan (comfortable)
        60-70°C = Green (warm)
        70-80°C = Yellow (getting hot)
        80-85°C = Orange (hot!)
        > 85°C  = Red (critical!)
        """
        if temp < 50:
            return RGBColor(0, 100, 255)  # Blue
        elif temp < 60:
            return RGBColor(0, 255, 255)  # Cyan
        elif temp < 70:
            return RGBColor(0, 255, 0)  # Green
        elif temp < 80:
            return RGBColor(255, 255, 0)  # Yellow
        elif temp < 85:
            return RGBColor(255, 165, 0)  # Orange
        else:
            return RGBColor(255, 0, 0)  # Red

    def get_temp_description(self, temp: float) -> str:
        """Get temperature status description"""
        if temp < 50:
            return "Cool ❄️"
        elif temp < 60:
            return "Comfortable 😊"
        elif temp < 70:
            return "Warm 🌡️"
        elif temp < 80:
            return "Getting Hot 🔥"
        elif temp < 85:
            return "Hot! ⚠️"
        else:
            return "CRITICAL! 🚨"

    def set_colour(self, colour: RGBColor):
        """Set all devices to colour"""
        for device in self.devices:
            try:
                device.set_color(colour)
            except:
                pass

    def monitor(self, interval: int = 2):
        """Monitor CPU temperature and update RGB"""
        print(
            "\n╔════════════════════════════════════════════════════════════════════════════╗"
        )
        print(
            "║              SPECTRA RGB - CPU Temperature Monitor                        ║"
        )
        print(
            "╚════════════════════════════════════════════════════════════════════════════╝\n"
        )

        print("🌡️  Monitoring CPU temperature...")
        print("   RGB colour changes based on temperature:")
        print("   • < 50°C  = Blue (cool)")
        print("   • 50-60°C = Cyan (comfortable)")
        print("   • 60-70°C = Green (warm)")
        print("   • 70-80°C = Yellow (getting hot)")
        print("   • 80-85°C = Orange (hot!)")
        print("   • > 85°C  = Red (critical!)\n")
        print("   Press Ctrl+C to stop...\n")

        last_colour = None

        try:
            while True:
                temp = self.get_cpu_temp()

                if temp is None:
                    print("⚠️  Unable to read CPU temperature")
                    time.sleep(interval)
                    continue

                colour = self.temp_to_colour(temp)
                status = self.get_temp_description(temp)

                # Only update if colour changed (reduces API calls)
                if colour != last_colour:
                    self.set_colour(colour)
                    last_colour = colour

                # Print status
                print(
                    f"\r🌡️  CPU: {temp:.1f}°C | Status: {status} | RGB: ({colour.red}, {colour.green}, {colour.blue})   ",
                    end="",
                    flush=True,
                )

                time.sleep(interval)

        except KeyboardInterrupt:
            print("\n\n👋 Stopping temperature monitor...")
            print("   RGB will stay at last colour.")
            print("   Use: python rgb-control.py work (or another mode) to change.\n")


def main():
    """Main entry point"""
    monitor = CPUTemperatureRGB()
    monitor.monitor(interval=2)


if __name__ == "__main__":
    main()



