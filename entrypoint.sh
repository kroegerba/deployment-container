#!/bin/sh

# exit entrypoint.sh as soon as something has an exit code other than 0 (error)
set -e

CONFIG="/config/settings.json"

# JSON lesen (Node ist vorhanden)
json() {
  node -p "(() => {try {
    const j = require('fs').readFileSync('$CONFIG', 'utf8');
    return JSON.parse(j)['$1'] ?? '';
  } catch { return ''; }})()"
}

# Settings (falls vorhanden)
if [ -f "$CONFIG" ]; then
  export GIT_URL="$(json url)"
  export GIT_BRANCH="$(json branch || echo master)"
  export DEST="$(json dest || echo /destination)"

  git clone --depth=1 --branch $GIT_BRANCH $GIT_URL src
else
  echo "⚠️   no settings.json found"
fi

exec "$@"
