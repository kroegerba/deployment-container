#!/bin/sh

# exit entrypoint.sh as soon as something has an exit code other than 0 (error)
set -e

echo "what's up?"

exec "$@"
