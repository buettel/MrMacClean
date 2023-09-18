@echo off && mode con cols=60 lines=40 && color 4f
Title Remove Mac footprint

REM Control if it already runs.
IF exist MrMacClean.bat_arbeitet.ps1 (
  echo MrMacClean is running!
  timeout 3
  exit
)

echo Remove, recursively Mac Footprint from this Drive %CD%.
echo I know what I do.
echo It is not reversible.
echo To stop this close the window,
echo else 
pause

cd /

REM Files in MACFILES will be deleted recursively
REM Feel free to add files or directories.

set MACFILES[0]=.history
set MACFILES[1]=.fseventsd
set MACFILES[2]=.Spotlight-V100
set MACFILES[3]=.Trashes
set MACFILES[4]=.TemporaryItems
set MACFILES[5]=.DS_Store
set MACFILES[6]=._

set x=0

echo Start deleting ...
setlocal enableDelayedExpansion
:SymLoop
if defined MACFILES[%x%] (

REM Powershell is more evective.
REM Create MrMacClean.bat_arbeitet.ps1, it will do the work. Delete once and forever.

  @echo $I = Get-ChildItem -Path !MACFILES[%x%]!* -Recurse -Force -ErrorAction SilentlyContinue >> MrMacClean.bat_arbeitet.ps1
  @echo  IF ^( $I ^){ Remove-Item $I.fullname -Recurse -ErrorAction SilentlyContinue -Force -Confirm:$false } >> MrMacClean.bat_arbeitet.ps1

  @echo $a+=1 >> MrMacClean.bat_arbeitet.ps1
  @echo $I = Get-ChildItem -Path !MACFILES[%x%]! -Recurse -Force -ErrorAction SilentlyContinue >> MrMacClean.bat_arbeitet.ps1
  @echo IF ^( $I ^){ Remove-Item $I.fullname -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false } >> MrMacClean.bat_arbeitet.ps1
  @echo Write-Output " $a) !MACFILES[%x%]!" >> MrMacClean.bat_arbeitet.ps1

  set /a x+=1
  GOTO :SymLoop
)
endlocal

REM pause
@echo Write-Output " " >> MrMacClean.bat_arbeitet.ps1
@echo Write-Output "---" >> MrMacClean.bat_arbeitet.ps1
REM @echo Timeout /T 10 >> MrMacClean.bat_arbeitet.ps1


Powershell.exe -executionpolicy remotesigned -File MrMacClean.bat_arbeitet.ps1

%SystemRoot%\system32\msg.exe /W * Mister Mac Clean ist fertig!

DEL /Q MrMacClean.bat_arbeitet.ps1
