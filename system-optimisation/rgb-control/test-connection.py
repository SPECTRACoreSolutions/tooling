#!/usr/bin/env python3
"""Test OpenRGB SDK connection"""

print("\n🧪 Testing OpenRGB SDK Connection...\n")

# Test import
try:
    from openrgb import OpenRGBClient
    from openrgb.utils import RGBColor

    print("✅ OpenRGB Python SDK imported successfully")
except ImportError as e:
    print(f"❌ Failed to import OpenRGB SDK: {e}")
    print("   Run: pip install openrgb-python")
    exit(1)

# Test connection
try:
    print("🔌 Connecting to OpenRGB at 127.0.0.1:6742...")
    client = OpenRGBClient()
    print("✅ Connected to OpenRGB SDK Server!")

    # List devices
    print(f"\n📍 Detected {len(client.devices)} RGB device(s):\n")
    for i, device in enumerate(client.devices, 1):
        print(f"   {i}. {device.name}")
        print(f"      Type: {device.type}")
        print(f"      Zones: {len(device.zones)}")
        print(f"      LEDs: {len(device.leds)}")
        print()

    print("═══════════════════════════════════════════════════════════════════════════")
    print("                         ✅ EVERYTHING WORKING!")
    print(
        "═══════════════════════════════════════════════════════════════════════════\n"
    )
    print("🎨 You can now use:")
    print("   python rgb-control.py work")
    print("   python rgb-control.py gaming")
    print("   python cpu-temp-rgb.py\n")

except ConnectionRefusedError:
    print("❌ Connection refused!")
    print("   OpenRGB SDK Server is not running.")
    print("\n   In OpenRGB:")
    print("   1. Go to 'SDK Server' tab")
    print("   2. Click 'Start Server'")
    print("   3. Enable 'Auto-start server'\n")

except Exception as e:
    print(f"❌ Error: {e}\n")



