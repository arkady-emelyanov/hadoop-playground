#!/bin/bash
set -eo pipefail

# first time start: generate host keys
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    /usr/bin/ssh-keygen -A > /dev/null
fi
exec /usr/sbin/sshd -D
