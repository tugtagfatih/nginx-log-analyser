#!/bin/bash
TERMINAL_WIDTH=$(tput cols)
HEADER_TEXT=" nginx log analyzer "
HEADER_LENGTH=${#HEADER_TEXT}
DASH_COUNT=$(((TERMINAL_WIDTH - HEADER_LENGTH) / 2))
DASHES=$(printf '%*s' $DASH_COUNT | tr ' ' '-')
BLANK=$(printf '%*s' $TERMINAL_WIDTH | tr ' ' '-')


echo "${DASHES}${HEADER_TEXT}${DASHES}"


if [ -n "$1" ]; then
    LOG_FILE="$1"
else
    LOG_FILE="access.log"
    if [ ! -f "$LOG_FILE" ]; then
        LOG_FILE="nginx-access.log"
    fi
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Log file not found: $LOG_FILE"
    echo "Please specify the log file location"
    echo "$BLANK"
    exit 1
fi

echo "Using log file: $LOG_FILE"
echo "$BLANK"

echo "Top 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'

echo "$BLANK"

echo "Top 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'

echo "$BLANK"

echo "Top 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'

echo "$BLANK"

echo "Top 5 user agents:"
awk -F '"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $2 " - " $1 " requests"}'

echo "$BLANK"

