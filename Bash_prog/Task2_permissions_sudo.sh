```bash
#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task2_permissions_sudo.sh
# @author       Azindo Abdul Razak
# @index        4186224
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Displays and changes file permissions and demonstrates
#               checking for root privileges before using chown.
# @date         9/14/2026
# -----------------------------------------------------------------

# Display instructions for using the script.
usage() {
  echo "Usage: $0 <file-path>"
  echo "  <file-path>  path of the file whose permissions will be changed"
}

# Show help if requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Make sure exactly one file path is provided.
if [[ $# -ne 1 || -z "$1" ]]; then
  echo "Error: Please provide one file path." >&2
  usage
  exit 1
fi

FILE="$1"

# Check that the file exists and is a regular file.
if [[ ! -f "$FILE" ]]; then
  echo "Error: File '$FILE' does not exist or is not a regular file." >&2
  exit 1
fi

# Step 1: Display the current permissions.
echo "Current permissions for: $FILE"

PERMISSIONS=$(stat -c "%A" "$FILE")
if [[ $? -ne 0 ]]; then
  echo "Error: Could not read the file permissions." >&2
  exit 1
fi

SYMBOLIC="${PERMISSIONS:1}"
NUMERIC=$(stat -c "%a" "$FILE")

if [[ $? -ne 0 ]]; then
  echo "Error: Could not read the numeric permissions." >&2
  exit 1
fi

echo "Symbolic: $SYMBOLIC"
echo "Numeric:  $NUMERIC"

# Step 2: Change permissions using numeric chmod syntax.
if chmod 644 "$FILE"; then
  echo "Permissions changed using numeric syntax: chmod 644"
else
  echo "Error: Failed to change permissions using chmod 644." >&2
  exit 1
fi

# Step 3: Change permissions using symbolic chmod syntax.
if chmod u+x "$FILE"; then
  echo "Permissions changed using symbolic syntax: chmod u+x"
else
  echo "Error: Failed to change permissions using chmod u+x." >&2
  exit 1
fi

# Step 4: Check whether the script is running as root.
if [[ "$(id -u)" -eq 0 ]]; then
  echo "Root privileges detected. Attempting to change file ownership."

  if chown root:root "$FILE"; then
    echo "Ownership changed successfully to root:root."
  else
    echo "Error: Failed to change file ownership." >&2
    exit 1
  fi
else
  echo "Not running as root. The chown step was skipped because root privileges are required."
fi

# Step 5: Display the permissions after the changes.
echo "Permissions after changes:"

PERMISSIONS=$(stat -c "%A" "$FILE")
if [[ $? -ne 0 ]]; then
  echo "Error: Could not read the updated permissions." >&2
  exit 1
fi

SYMBOLIC="${PERMISSIONS:1}"
NUMERIC=$(stat -c "%a" "$FILE")

if [[ $? -ne 0 ]]; then
  echo "Error: Could not read the updated numeric permissions." >&2
  exit 1
fi

echo "Symbolic: $SYMBOLIC"
echo "Numeric:  $NUMERIC"

echo "Task 2 completed successfully."
exit 0
```
