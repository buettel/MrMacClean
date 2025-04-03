@echo off
mode con cols=60 lines=40
color 4f
Title Remove Mac Footprint

:: Check if the script is already running.
IF exist "MrMacClean.bat_arbeitet.ps1" (
    echo MrMacClean is already running!
    timeout /T 3 >nul
    exit /B
)

:: Check if the script is running with administrative privileges.
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Requesting administrative privileges...
    PowerShell Start-Process "%~f0" -Verb RunAs
    exit /B
)

echo Removing Mac footprint recursively from this Drive: "%CD%".
echo.
echo WARNING: This operation is irreversible.
echo To stop, close the window now.
pause

:: Navigate to the root directory of the current drive.
cd /

:: Define arrays for files/directories to delete (root-level and recursive).
setlocal enableDelayedExpansion

:: Root-level files/directories to delete.
set "root_MACFILES[0]=.DocumentRevisions-V100"
set "root_MACFILES[1]=.fseventsd"
set "root_MACFILES[2]=.Spotlight-V100"
set "root_MACFILES[3]=.Trashes"
set "root_MACFILES[4]=.TemporaryItems"
set "root_MACFILES[5]=.VolumeIcon.icns"
set "root_MACFILES[6]=.com.apple.timemachine.donotpresent"

:: Recursive files/directories to delete.
set "recursive_MACFILES[0]=.DS_Store"
set "recursive_MACFILES[1]=.AppleDouble"
set "recursive_MACFILES[2]=.LSOverride"
set "recursive_MACFILES[3]=._"

:: Check if any Mac-specific files exist; if not, skip directly to cleanup.
IF NOT exist ".fseventsd" (
    set "x=6"
) ELSE (
    set "x=0"
)

set "y=0"
set "z=1"

echo Starting deletion process...

:: Create a PowerShell script to handle the deletion tasks.
> "MrMacClean.bat_arbeitet.ps1" (
    echo $cnt = 0
    echo Write-Output "Deleting Mac-specific files and directories..."

    :: Loop through root-level files/directories.
    :SymLoop_root
    if defined "root_MACFILES[%x%]" (
        echo $I = Get-ChildItem -Path "!root_MACFILES[%x%]!" -Force -ErrorAction SilentlyContinue
        echo $cnt += $I.Count
        echo if ($I) { Remove-Item $I.FullName -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false }
        echo Write-Output " %z%) !root_MACFILES[%x%]!"
        set /a x+=1
        set /a z+=1
        GOTO :SymLoop_root
    )

    :: Loop through recursive files/directories.
    :SymLoop_recu
    if defined "recursive_MACFILES[%y%]" (
        echo $I = Get-ChildItem -Path "!recursive_MACFILES[%y%]!" -Recurse -Force -ErrorAction SilentlyContinue
        echo $cnt += $I.Count
        echo if ($I) { Remove-Item $I.FullName -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false }
        echo Write-Output " %z%) !recursive_MACFILES[%y%]!"
        set /a y+=1
        set /a z+=1
        GOTO :SymLoop_recu
    )

    :: Final output.
    echo Write-Output " "
    echo Write-Output "---"
    echo Write-Output "Total deleted Files/Dirs: $cnt"
    echo Write-Output "---"
    echo [System.Windows.Forms.MessageBox]::Show("[$cnt] - Mister Mac Clean has finished!", "Cleanup Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information) | Out-Null
)

:: Execute the PowerShell script.
Powershell.exe -ExecutionPolicy RemoteSigned -File "MrMacClean.bat_arbeitet.ps1"

:: Clean up the temporary PowerShell script.
DEL /Q "MrMacClean.bat_arbeitet.ps1"

endlocal
