#!/bin/sh

# Path to the directory to monitor
WATCH_DIR="./models"
# Path to the virtual environment
VENV_DIR="./.venv"

# Ensure the virtual environment exists
if [ ! -d "$VENV_DIR" ]; then
    echo "Virtual environment not found! Creating one..."
    python3 -m venv "$VENV_DIR"
fi

# Activate the virtual environment
. "$VENV_DIR/bin/activate"

# Function to run the Python script
run_python_script() {
    filepath="$1"
    script_dir=$(dirname "$filepath")
    script_name=$(basename "$filepath")

    echo "Running script: $filepath"
    # Change to the script's directory and run the script
    (cd "$script_dir" && python3 "$script_name")
}

# Monitor the directory for changes in Python files
inotifywait -r -m -e close_write --format '%w%f' "$WATCH_DIR" | while read FILE; do
    if [ "${FILE##*.}" = "py" ]; then
        echo "Detected change in $FILE"
        run_python_script "$FILE"
    fi
done
