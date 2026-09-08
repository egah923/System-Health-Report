#!/bin/bash

# ============================================================
# System Health Report
# Usage: ./system_health.sh
# ============================================================

LOGFILE="/var/log/system_health.log"

{

echo "============SYSTEM HEALTH REPORT==============="
echo

echo "Date: $(date)"
echo

echo "Hostname: $(uname -r)"
echo

echo "Uptime: $(uptime)"
echo

USAGE=$(top -bn1 | head -n 2 | tail -n 1 | awk '{print $2}')
echo "CPU Usage: ${USAGE}"
echo

free -g | awk '/^Mem:/ {print "Memory Usage: " $3 "G / " $2 "G"}'
echo

ip addr show | grep '127' | awk '{printf "Network IP:" $2}'
echo

usage=$(df / | tail -1 | awk '{print $5}')
usage=${usage%\%}
echo

if [ $usage -gt 80 ]; then
    echo "WARNING: Disk usage is ${usage}%"
else
    echo "Disk usage is ${usage}%"
fi
echo

TARGET="google.com"

# Ping the target 3 times, sending output to /dev/null to keep the terminal
if ping -c 3 "$TARGET" > /dev/null 2>&1; then
    echo "Success: $TARGET is reachable."
else
    echo "Failure: $TARGET is unreachable."
fi
echo
} | tee -a $LOGFILE
