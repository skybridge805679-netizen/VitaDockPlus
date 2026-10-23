#!/bin/bash

# Sets a configuration key in vitadock.conf
# If the key does not exist yet it is appended, so configs from older
# images pick up new keys automatically.

# Usage: /home/pi/updateConfig.sh <ConfigurationKey> <Value>

CONF="${VITADOCK_CONF:-/home/pi/vitadock.conf}"
CFGKEY=$1
CFGVAL=$2

if [ -z "$CFGKEY" ]
then
    echo "Missing configuration key argument"
    exit 1
fi

if [ -z "$CFGVAL" ]
then
    echo "Missing configuration value"
    exit 1
fi

# The key and value are passed through the environment so characters such as
# "/" or "&" in a value can never be misread as part of a sed/awk program.
export CFGKEY CFGVAL
TMP=$(mktemp) || exit 1

if grep -q -E "^${CFGKEY}=" "$CONF"
then
    awk 'BEGIN { FS = OFS = "=" }
         $1 == ENVIRON["CFGKEY"] { print ENVIRON["CFGKEY"] "=" ENVIRON["CFGVAL"]; next }
         { print }' "$CONF" > "$TMP"
else
    cp "$CONF" "$TMP"
    # The shipped config has no trailing newline, add one before appending.
    [ -n "$(tail -c 1 "$TMP")" ] && echo >> "$TMP"
    echo "${CFGKEY}=${CFGVAL}" >> "$TMP"
fi

# Write in place instead of moving so the file keeps its owner and permissions.
cat "$TMP" > "$CONF"
rm -f "$TMP"
