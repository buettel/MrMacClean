# MrMacClean

Remove Mac footprint from volume. <br>
For removable Devices. Out of the box **Windows** Script. Start it and feel free.
It creates a **powershell** script **MrMacClean.bat_arbeitet.ps1** to do the work.

TODO: root of a volume and not recursive, make the difference.

Removes Mac files and directories:
### root of a Volume

- .DocumentRevisions-V100
- .fseventsd
- .Spotlight-V100
- .Trashes
- .TemporaryItems
- .VolumeIcon.icns
- .com.apple.timemachine.donotpresent

### recursive
- .DS_Store
- .AppleDouble
- .LSOverride
- ._

and more ... just add to the script, but it deletes. It is not reversible.

