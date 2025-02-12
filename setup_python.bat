@echo off
echo Setting up Python virtual environment...

:: Ensure the backend folder exists
if not exist backend (
    mkdir backend
)

:: Create virtual environment inside backend folder
if not exist backend\venv (
    python -m venv backend\venv
    echo Virtual environment created in backend\venv.
) else (
    echo Virtual environment already exists.
)

:: Activate virtual environment
call backend\venv\Scripts\activate

:: Install dependencies
if exist backend\requirements.txt (
    echo Installing dependencies...
    pip install -r backend\requirements.txt
) else (
    echo No requirements.txt found, skipping dependency installation.
)

echo Python environment setup complete!
pause
