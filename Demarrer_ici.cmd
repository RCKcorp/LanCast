@echo off
REM ====================================================================
REM  LANCast - Lanceur double-clic
REM  Demande l'elevation administrateur puis demarre Install-LANCast.ps1
REM ====================================================================

setlocal
cd /d "%~dp0"

echo.
echo ==================================================================
echo   LANCast - Installation automatique
echo ==================================================================
echo.
echo   Une fenetre PowerShell va s'ouvrir (avec demande UAC).
echo   Repondre OUI a l'invite Windows pour autoriser l'elevation.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install\Install-LANCast.ps1"

endlocal
