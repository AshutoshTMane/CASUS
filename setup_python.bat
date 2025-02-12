@echo off
echo Setting up Python virtual environment...

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH. Please install Python and try again.
    pause
    exit /b
)

:: Create virtual environment if it doesn't exist
if not exist "venv\" (
    echo Creating virtual environment...
    python -m venv venv
    if exist "venv\Scripts\activate.bat" (
        echo Virtual environment created successfully.
    ) else (
        echo Failed to create virtual environment.
        pause
        exit /b
    )
) else (
    echo Virtual environment already exists.
)

:: Activate virtual environment
call venv\Scripts\activate

:: Upgrade pip
python -m pip install --upgrade pip

:: Install dependencies
if exist "requirements.txt" (
    echo Installing dependencies...
    pip install -r requirements.txt
) else (
    echo No requirements.txt found, skipping dependency installation.
)

echo Python environment setup complete!
pause
