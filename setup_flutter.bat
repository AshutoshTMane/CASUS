@echo off
setlocal

echo [DEBUG] Starting Flutter setup script...

:: Check if Flutter is installed
echo [DEBUG] Checking if Flutter is installed...

:: Set project name to "flutter_app"
set app_name=flutter_app
echo [DEBUG] Project name set to: %app_name%

:: Check if project directory already exists
if exist "%app_name%" (
    echo [ERROR] Directory '%app_name%' already exists! Choose a different name or delete the existing folder.
    pause
    exit /b
)
echo [DEBUG] Directory does not exist, proceeding with creation.

:: Create the Flutter project
echo [DEBUG] Running: flutter create "%app_name%"...
flutter create "%app_name%" 2> flutter_error.log
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create Flutter project. Check 'flutter_error.log' for details.
    type flutter_error.log
    pause
    exit /b
)
echo [DEBUG] Flutter project created successfully.

:: Navigate into the project folder
cd "%app_name%" || (
    echo [ERROR] Failed to enter project directory '%app_name%'. Check if it was created.
    pause
    exit /b
)
echo [DEBUG] Changed directory to: %app_name%

:: Get dependencies
echo [DEBUG] Running flutter pub get...
flutter pub get 2> flutter_pub_error.log
if %errorlevel% neq 0 (
    echo [ERROR] Failed to fetch dependencies. Check 'flutter_pub_error.log' for details.
    type flutter_pub_error.log
    pause
    exit /b
)
echo [DEBUG] Dependencies installed successfully.

:: Final message
echo [SUCCESS] Flutter project '%app_name%' has been created successfully!
pause
