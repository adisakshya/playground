#!/bin/bash

show_proxy_messages=1

print_msg() {
    # \x0d clears the line so [Working] is hidden
    [ "$show_proxy_messages" = 1 ] && printf '\x0d%s\n' "$1" >&2
}

echo "Proxy: $1:$2"
PROXY_STATUS=$((timeout 1 bash -c '</dev/tcp/'$1'/'$2' && echo AVAILABLE || echo CLOSED') 2>/dev/null)
echo "Proxy Status: $PROXY_STATUS"
# if the host machine / proxy is reachable...
if [[ $PROXY_STATUS == 'AVAILABLE' ]]; then
    proxy=http://$proxy
    print_msg "Proxy that will be used: http://$1:$2"
    echo "Acquire::http { Proxy \"http://$1:$2\"; };" >> /etc/apt/apt.conf.d/01proxy
    exit
fi
print_msg "No proxy will be used"

# Workaround for Launchpad bug 654393 so it works with Debian Squeeze (<0.8.11)
echo DIRECT
