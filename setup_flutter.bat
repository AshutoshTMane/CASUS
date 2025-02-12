@echo off
echo Setting up Flutter project...

:: Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter is not installed. Please install Flutter first.
    pause
    exit /b
)

:: Ask for project name
set /p app_name=Enter your Flutter project name: 

:: Create the Flutter project
flutter create %app_name%

:: Navigate into the project folder
cd %app_name%

:: Get dependencies
echo Running flutter pub get...
flutter pub get

echo Flutter project '%app_name%' has been created successfully!
pause
