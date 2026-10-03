#!/bin/bash

LOG_FILE="/var/log/system_health.log"

# Use sudo if the script is not running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo ./system_health.sh"
    exit 1
fi

# Start report
{
echo "=========================================="
echo "       SYSTEM HEALTH REPORT"
echo "=========================================="
echo "Date: $(date)"
echo ""

# System Information
echo "----- SYSTEM INFORMATION -----"
echo "Hostname: $(hostname)"
echo "OS Version:"
lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME
echo "Kernel Version: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo ""

# CPU Information
echo "----- CPU USAGE -----"
echo "Top CPU-consuming processes:"
ps aux --sort=-%cpu | head -6
echo ""

# Memory
echo "----- MEMORY USAGE -----"
free -h
echo ""

# Disk
echo "----- DISK USAGE -----"
df -h
echo ""

echo "Disk Usage Warnings:"
df -h | awk 'NR>1 && $5+0 > 80 {print "WARNING: " $6 " is " $5 " full"}'
echo ""

# Network
echo "----- NETWORK STATUS -----"
echo "IP Addresses:"
ip -br addr
echo ""

echo "Connectivity Test:"
if ping -c 2 -W 2 google.com > /dev/null 2>&1; then
    echo "Network: OK (google.com reachable)"
else
    echo "Network: FAILED (google.com unreachable)"
fi
echo ""

# Services
echo "----- SERVICES -----"

for service in ssh apache2; do
    if systemctl is-active --quiet "$service"; then
        echo "$service: ACTIVE"
    else
        echo "$service: INACTIVE"
    fi
done

echo ""
echo "Report generated: $(date)"
echo "=========================================="

} | tee -a "$LOG_FILE"

echo ""
echo "Report saved to $LOG_FILE"
