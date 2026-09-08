# System Health Monitor

A simple Bash script that monitors basic Linux server health and generates a system health report.

### Checks

* CPU usage
* Memory usage
* Disk usage
* Network IP
* Hostname
* System uptime

### Disk Alert

Displays a warning when disk usage exceeds **80%**.

### Usage

```bash
chmod +x system_health.sh
./system_health.sh
```

Reports can be logged to:

```text
/var/log/system_health.log
```

Built with **Bash and standard Linux utilities**.
