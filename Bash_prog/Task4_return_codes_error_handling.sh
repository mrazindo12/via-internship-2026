#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task4_return_codes_error_handling.sh
# @author       Azindo Abdul Razak
# @index        4186224
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Performs system checks and demonstrates return-code
#               handling, specific exit codes, and cleanup with trap.
# @date         9/14/2026
#
# Exit codes:
#   0 = all checks passed
#   1 = missing required argument
#   2 = host unreachable
#   3 = insufficient disk space
#   4 = required file not found or not readable
#   5 = required command not found
# -----------------------------------------------------------------

# File used temporarily by the script.
TEMP_FILE="task4_temp.txt"

# Remove temporary files when the script exits or is interrupted.
cleanup() {
  rm -f "$TEMP_FILE"
}

trap cleanup EXIT INT TERM

# Display instructions for using the script.
usage() {
  echo "Usage: $0 <hostname>"
  echo "  <hostname>  host to check for network connectivity"
}

# Show help if requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Check that a hostname was provided.
if [[ $# -ne 1 ]]; then
  echo "Error: A hostname is required." >&2
  usage
  exit 1
fi

HOST="$1"

# Check the result of each command.
check_status() {
  STATUS=$?
  MESSAGE="$1"
  EXIT_CODE="$2"

  if [[ $STATUS -eq 0 ]]; then
    echo "PASS: $MESSAGE"
  else
    echo "FAIL: $MESSAGE" >&2
    exit "$EXIT_CODE"
  fi
}

# ---------------------------------------------------------------
# Check 1: Make sure ping is installed.
# ---------------------------------------------------------------
command -v ping > /dev/null 2>&1
check_status "ping command is installed." 5

# ---------------------------------------------------------------
# Check 2: Check whether the host is reachable.
# ---------------------------------------------------------------
ping -c 1 -W 2 "$HOST" > /dev/null 2>&1
check_status "Host '$HOST' is reachable." 2

# ---------------------------------------------------------------
# Check 3: Check whether enough disk space is available.
# ---------------------------------------------------------------
df / > "$TEMP_FILE"

if [[ $? -eq 0 ]]; then
  FREE_SPACE=$(awk 'NR==2 {print $4}' "$TEMP_FILE")

  if [[ "$FREE_SPACE" -ge 1048576 ]]; then
    DISK_STATUS=0
  else
    DISK_STATUS=1
  fi
else
  DISK_STATUS=1
fi

if [[ $DISK_STATUS -eq 0 ]]; then
  echo "PASS: Enough free disk space is available."
else
  echo "FAIL: Insufficient free disk space." >&2
  exit 3
fi

# ---------------------------------------------------------------
# Check 4: Check that a required configuration file exists
# and can be read.
# ---------------------------------------------------------------
CONFIG_FILE="/etc/hosts"

if [[ -f "$CONFIG_FILE" && -r "$CONFIG_FILE" ]]; then
  FILE_STATUS=0
else
  FILE_STATUS=1
fi

check_status "Required file '$CONFIG_FILE' exists and is readable." 4

# All checks passed.
echo
echo "All checks passed successfully."
exit 0