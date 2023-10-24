#!/bin/sh
exec /bin/start.sh &
exec /usr/local/bin/gotty --port 80 --permit-write --reconnect /bin/bash