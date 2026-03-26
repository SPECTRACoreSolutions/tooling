# Quick memory check (SMBIOS/WMI) - no prompts. Use after CMOS reset to see if XMP is off.
$ram = Get-CimInstance Win32_PhysicalMemory
$totalGB = [math]::Round(($ram | Measure-Object Capacity -Sum).Sum / 1GB, 2)
$speed = $ram[0].Speed
Write-Host "Total RAM: $totalGB GB"
Write-Host "Reported speed: $speed MHz (per stick)"
foreach ($stick in $ram) {
    $capGB = [math]::Round($stick.Capacity / 1GB, 0)
    $man = if ($stick.Manufacturer) { $stick.Manufacturer.Trim() } else { "" }
    $pn = if ($stick.PartNumber) { $stick.PartNumber.Trim() } else { "" }
    Write-Host "  Stick: $capGB GB @ $($stick.Speed) MHz | $man | $pn"
}
Write-Host ""
if ($speed -ge 8000) { Write-Host "XMP/EXPO: likely ENABLED (running at or near rated 8400)" }
elseif ($speed -ge 6000) { Write-Host "XMP/EXPO: may be enabled at a lower profile. Your kit: Corsair 8400; enable XMP Profile 1 for full speed." }
else { Write-Host "XMP/EXPO: likely OFF. Enable XMP Profile 1 in BIOS for 8400 MT/s." }
