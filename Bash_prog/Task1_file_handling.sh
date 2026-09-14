```bash
#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task1_file_handling.sh
# @author       Abdul Razak Azindo
# @index        4186224
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Demonstrates basic file handling by creating, writing,
#               reading, backing up, and deleting a file.
# @date         9/14/2026
# -----------------------------------------------------------------

# Display instructions for using the script.
usage() {
  echo "Usage: $0 <target-directory>"
  echo "  <target-directory>  directory where the file will be created"
}

# Show help if requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Make sure exactly one directory is provided.
if [[ $# -ne 1 || -z "$1" ]]; then
  echo "Error: Please provide one target directory." >&2
  usage
  exit 1
fi

TARGET_DIR="$1"
FILE="$TARGET_DIR/task1.txt"
BACKUP="$TARGET_DIR/task1.txt.bak"

# Make sure an existing target path is a directory.
if [[ -e "$TARGET_DIR" && ! -d "$TARGET_DIR" ]]; then
  echo "Error: '$TARGET_DIR' is not a directory." >&2
  exit 1
fi

# Step 1: Create the target directory if needed.
if [[ ! -d "$TARGET_DIR" ]]; then
  if mkdir -p "$TARGET_DIR"; then
    echo "Directory created: $TARGET_DIR"
  else
    echo "Error: Could not create '$TARGET_DIR'." >&2
    exit 1
  fi
else
  echo "Directory already exists: $TARGET_DIR"
fi

# Step 2: Create the file and write the first content.
if echo "This is my Bash file handling task." > "$FILE"; then
  echo "File created and initial content written."
else
  echo "Error: Could not create or write to '$FILE'." >&2
  exit 1
fi

# Step 3: Add more content without removing the existing content.
if echo "This line was added using append." >> "$FILE"; then
  echo "Additional content appended successfully."
else
  echo "Error: Could not append content to '$FILE'." >&2
  exit 1
fi

# Step 4: Display the contents of the file.
echo "Contents of $FILE:"
if cat "$FILE"; then
  echo "File read successfully."
else
  echo "Error: Could not read '$FILE'." >&2
  exit 1
fi

# Step 5: Make a backup only if the original file exists.
if [[ -f "$FILE" ]]; then
  if cp "$FILE" "$BACKUP"; then
    echo "Backup created: $BACKUP"
  else
    echo "Error: Could not create the backup file." >&2
    exit 1
  fi
else
  echo "Error: '$FILE' does not exist." >&2
  exit 1
fi

# Step 6: Check the original file before deleting it.
if [[ -f "$FILE" ]]; then
  echo "Confirmation: '$FILE' will now be deleted."

  if rm "$FILE"; then
    echo "Original file deleted successfully."
  else
    echo "Error: Could not delete '$FILE'." >&2
    exit 1
  fi
else
  echo "Error: Original file was not found. Nothing was deleted." >&2
  exit 1
fi

echo "Task 1 completed successfully."
exit 0
```
