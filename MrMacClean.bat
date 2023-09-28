@echo off && mode con cols=60 lines=40 && color 4f
Title Remove Mac footprint

REM Check if it already runs.
IF exist MrMacClean.bat_arbeitet.ps1 (
  echo MrMacClean is running!
  timeout 3
  exit
)

echo Remove, recursively Mac Footprint from this Drive %CD%.
echo.
echo I know what I do. It is not reversible.
echo To stop this, close the window or else 
pause

cd /

  REM Files in MACFILES will be deleted recursivly
  REM Feel free to add files or directories.
  set root_MACFILES[0]=.DocumentRevisions-V100
  set root_MACFILES[1]=.fseventsd
  set root_MACFILES[2]=.Spotlight-V100
  set root_MACFILES[3]=.Trashes
  set root_MACFILES[4]=.TemporaryItems
  set root_MACFILES[5]=.DS_Store
  set root_MACFILES[6]=._

  set recursive_MACFILES[0]=.DS_Store
  set recursive_MACFILES[1]=._

REM Check Mac files, if not exits do only last job. MACFILES[6]=._
IF NOT exist .fseventsd (
  set x=6
) ELSE (
  set x=0
)

set x=0
set y=0
set z=1

echo Start deleting ...

REM Powershell is more evective.
REM Create MrMacClean.bat_arbeitet.ps1, it will do the work. Delete once and forever.

setlocal enableDelayedExpansion

  @echo $cnt=0 >> MrMacClean.bat_arbeitet.ps1

:SymLoop_root
if defined root_MACFILES[%x%] (

REM delete only in root dir
  @echo $I = Get-ChildItem -Path !root_MACFILES[%x%]!* -Recurse -Force -ErrorAction SilentlyContinue >> MrMacClean.bat_arbeitet.ps1
  @echo $cnt+=$I.Count >> MrMacClean.bat_arbeitet.ps1
  @echo  IF ^( $I ^){ Remove-Item $I.fullname -Recurse -ErrorAction SilentlyContinue -Force -Confirm:$false } >> MrMacClean.bat_arbeitet.ps1
  @echo Write-Output " %z%) !root_MACFILES[%x%]!" >> MrMacClean.bat_arbeitet.ps1

  set /a x=x+1
  set /a z=z+1
  GOTO :SymLoop_root
)

:SymLoop_recu
if defined recursive_MACFILES[%y%] (


  @echo $I = Get-ChildItem -Path !recursive_MACFILES[%y%]! -Recurse -Force -ErrorAction SilentlyContinue >> MrMacClean.bat_arbeitet.ps1
  @echo $cnt+=$I.Count >> MrMacClean.bat_arbeitet.ps1
  @echo IF ^( $I ^){ Remove-Item $I.fullname -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false } >> MrMacClean.bat_arbeitet.ps1
 
  set /a y+=1
  GOTO :SymLoop_recu
)
endlocal

REM pause
@echo Write-Output " " >> MrMacClean.bat_arbeitet.ps1
@echo Write-Output "---" >> MrMacClean.bat_arbeitet.ps1
@echo Write-Output " $cnt deleted Files/Dirs." >> MrMacClean.bat_arbeitet.ps1
@echo Write-Output "---" >> MrMacClean.bat_arbeitet.ps1
REM @echo Timeout /T 10 >> MrMacClean.bat_arbeitet.ps1


Powershell.exe -executionpolicy remotesigned -File MrMacClean.bat_arbeitet.ps1

%SystemRoot%\system32\msg.exe /W * Mister Mac Clean ist fertig!

DEL /Q MrMacClean.bat_arbeitet.ps1
