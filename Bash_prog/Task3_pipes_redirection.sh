#!/usr/bin/env bash
# -----------------------------------------------------------------
# @title        Task3_pipes_redirection.sh
# @author       Azindo Abdul Razak
# @index        4186224
# @school       Kwame Nkrumah University of Science and Technology (KNUST)
# @description  Generates sample log data and uses pipes, redirection,
#               and text processing tools to create a summary report.
# @date         9/14/2026
# -----------------------------------------------------------------

# Display instructions for using the script.
usage() {
  echo "Usage: $0"
  echo "  This script does not require any arguments."
}

# Show help if requested.
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  usage
  exit 0
fi

# Make sure no unnecessary arguments were provided.
if [[ $# -ne 0 ]]; then
  echo "Error: This script does not take any arguments." >&2
  usage
  exit 1
fi

LOG_FILE="sample_logs.txt"
RESULT_FILE="results.txt"
ERROR_FILE="errors.log"

# Create sample log data using a heredoc.
if cat > "$LOG_FILE" <<EOF
2026-09-11 10:03:21 INFO 192.168.1.10 User login successful
2026-09-11 10:03:45 ERROR 192.168.1.23 Connection timeout
2026-09-11 10:04:02 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:04:15 INFO 192.168.1.15 User login successful
2026-09-11 10:04:30 INFO 192.168.1.10 File uploaded
2026-09-11 10:04:45 ERROR 192.168.1.23 Database connection failed
2026-09-11 10:05:01 WARN 192.168.1.20 Memory usage above 80%
2026-09-11 10:05:15 INFO 192.168.1.10 User logout successful
2026-09-11 10:05:30 INFO 192.168.1.15 File downloaded
2026-09-11 10:05:45 ERROR 192.168.1.10 Permission denied
2026-09-11 10:06:02 WARN 192.168.1.20 High CPU usage
2026-09-11 10:06:15 INFO 192.168.1.23 User login successful
2026-09-11 10:06:30 INFO 192.168.1.10 Password changed
2026-09-11 10:06:45 ERROR 192.168.1.15 Connection timeout
2026-09-11 10:07:01 WARN 192.168.1.10 Disk usage above 80%
2026-09-11 10:07:15 INFO 192.168.1.20 User login successful
2026-09-11 10:07:30 INFO 192.168.1.10 File uploaded
2026-09-11 10:07:45 ERROR 192.168.1.23 Service unavailable
2026-09-11 10:08:01 WARN 192.168.1.15 Memory usage above 80%
2026-09-11 10:08:15 INFO 192.168.1.10 User logout successful
2026-09-11 10:08:30 INFO 192.168.1.20 File downloaded
2026-09-11 10:08:45 ERROR 192.168.1.10 Database connection failed
2026-09-11 10:09:01 WARN 192.168.1.10 High CPU usage
2026-09-11 10:09:15 INFO 192.168.1.15 User login successful
2026-09-11 10:09:30 INFO 192.168.1.10 Password changed
2026-09-11 10:09:45 ERROR 192.168.1.23 Permission denied
2026-09-11 10:10:01 WARN 192.168.1.20 Disk usage above 80%
2026-09-11 10:10:15 INFO 192.168.1.10 File uploaded
2026-09-11 10:10:30 INFO 192.168.1.15 User logout successful
2026-09-11 10:10:45 ERROR 192.168.1.23 Connection timeout
2026-09-11 10:11:01 WARN 192.168.1.10 Memory usage above 80%
2026-09-11 10:11:15 INFO 192.168.1.20 User login successful
2026-09-11 10:11:30 INFO 192.168.1.10 File downloaded
2026-09-11 10:11:45 ERROR 192.168.1.15 Service unavailable
2026-09-11 10:12:01 WARN 192.168.1.20 High CPU usage
2026-09-11 10:12:15 INFO 192.168.1.10 Password changed
2026-09-11 10:12:30 INFO 192.168.1.23 User login successful
2026-09-11 10:12:45 ERROR 192.168.1.10 Database connection failed
2026-09-11 10:13:01 WARN 192.168.1.15 Disk usage above 80%
2026-09-11 10:13:15 INFO 192.168.1.10 File uploaded
2026-09-11 10:13:30 INFO 192.168.1.20 User logout successful
2026-09-11 10:13:45 ERROR 192.168.1.23 Permission denied
2026-09-11 10:14:01 WARN 192.168.1.10 High CPU usage
2026-09-11 10:14:15 INFO 192.168.1.15 User login successful
2026-09-11 10:14:30 INFO 192.168.1.10 File downloaded
2026-09-11 10:14:45 ERROR 192.168.1.23 Connection timeout
2026-09-11 10:15:01 WARN 192.168.1.20 Memory usage above 80%
2026-09-11 10:15:15 INFO 192.168.1.10 Password changed
2026-09-11 10:15:30 INFO 192.168.1.23 User logout successful
2026-09-11 10:15:45 ERROR 192.168.1.15 Service unavailable
EOF
then
  echo "Sample log data created successfully."
else
  echo "Error: Could not create sample log data." >&2
  exit 1
fi

# Clear the old results and error files before creating new ones.
> "$RESULT_FILE"
> "$ERROR_FILE"

# Write the report to results.txt.
{
  echo "===== LOG SUMMARY ====="

  # Count all log lines.
  echo "Total log lines:"
  if wc -l < "$LOG_FILE"; then
    :
  else
    echo "Error: Could not count log lines." >&2
    exit 1
  fi

  # Count each log level using grep and wc.
  echo
  echo "Log level counts:"

  if grep " INFO " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count INFO lines." >&2
    exit 1
  fi

  if grep " WARN " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count WARN lines." >&2
    exit 1
  fi

  if grep " ERROR " "$LOG_FILE" | wc -l; then
    :
  else
    echo "Error: Could not count ERROR lines." >&2
    exit 1
  fi

  # Find the three most frequent IP addresses.
  echo
  echo "Top 3 IP addresses:"
  if awk '{print $4}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -3; then
    :
  else
    echo "Error: Could not find the top IP addresses." >&2
    exit 1
  fi

  # Display all ERROR lines.
  echo
  echo "ERROR lines:"
  if grep " ERROR " "$LOG_FILE"; then
    :
  else
    echo "Error: Could not find ERROR lines." >&2
    exit 1
  fi

} > "$RESULT_FILE" 2> "$ERROR_FILE"

# Check whether the report was created successfully.
if [[ $? -eq 0 ]]; then
  echo "Report created successfully: $RESULT_FILE"
else
  echo "Error: The report could not be created. Check $ERROR_FILE." >&2
  exit 1
fi

echo "Task 3 completed successfully."
exit 0