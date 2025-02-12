#!/bin/bash

echo "Creating necessary directories and .gitkeep files..."

# Create backend virtual environment directory
mkdir -p backend/venv && touch backend/venv/.gitkeep

# Create Flutter build directory
mkdir -p flutter_app/build && touch flutter_app/build/.gitkeep

# Create backend database directory
mkdir -p backend/database && touch backend/database/.gitkeep

# Create backend logs directory
mkdir -p backend/logs && touch backend/logs/.gitkeep

echo "All directories and .gitkeep files have been created!"
