@echo off
echo Creating necessary directories and .gitkeep files...

:: Create backend database directory
if not exist "backend\database" mkdir "backend\database"
echo. > "backend\database\.gitkeep"

:: Create backend logs directory
if not exist "backend\logs" mkdir "backend\logs"
echo. > "backend\logs\.gitkeep"

echo All directories and .gitkeep files have been created!
pause
