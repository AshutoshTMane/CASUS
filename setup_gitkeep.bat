@echo off
echo Creating necessary directories and .gitkeep files...

:: Create backend virtual environment directory
if not exist "backend\venv" mkdir "backend\venv"
echo. > "backend\venv\.gitkeep"

:: Create Flutter build directory
if not exist "flutter_app\build" mkdir "flutter_app\build"
echo. > "flutter_app\build\.gitkeep"

:: Create backend database directory
if not exist "backend\database" mkdir "backend\database"
echo. > "backend\database\.gitkeep"

:: Create backend logs directory
if not exist "backend\logs" mkdir "backend\logs"
echo. > "backend\logs\.gitkeep"

echo All directories and .gitkeep files have been created!
pause
