#!/bin/bash

# Check the output file path was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file>"
    exit 1
fi

OUTPUT_FILE="$1"

# Reset rules & default configuration
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# 1. provide local access to DB
ufw allow from 127.0.0.1 to any port 3306

# 2. admin panel (3005) accepts 192.168.32.55 only
ufw allow from 192.168.32.55 to any port 3005
ufw reject 3005

# 3. port 8099 via eth0 only
ufw allow in on eth0 to any port 8099

# 4. limit connetcions to ports 6050–6055
for port in {6050..6055}; do
    ufw limit $port/tcp
done

# Enable firewall & export configured rules to the file
ufw enable
ufw status numbered > "$OUTPUT_FILE"

echo "UFW rules were saved to the $OUTPUT_FILE"
