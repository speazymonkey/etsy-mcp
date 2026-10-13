#!/usr/bin/env bash
# Richtet den Etsy-MCP-Server für Noblez auf diesem Mac ein.
set -euo pipefail
cd "$(dirname "$0")"

command -v node >/dev/null || { echo "Node.js fehlt (>= 20). Bitte installieren: https://nodejs.org"; exit 1; }
command -v claude >/dev/null || { echo "Claude Code fehlt. Bitte installieren: npm install -g @anthropic-ai/claude-code"; exit 1; }

echo "1/4 npm install"
npm install --silent
echo "2/4 npm run build"
npm run build --silent

if [ ! -f .env ]; then
  echo "3/4 Zugangsdaten (aus https://www.etsy.com/developers/, App noblez-shop-tools)"
  read -r -p "ETSY_API_KEY (Keystring): " KEY
  read -r -s -p "ETSY_SHARED_SECRET: " SECRET; echo
  printf 'ETSY_API_KEY=%s\nETSY_SHARED_SECRET=%s\nETSY_OAUTH_PORT=3003\n' "$KEY" "$SECRET" > .env
  chmod 600 .env
else
  echo "3/4 .env existiert schon, wird übernommen"
fi

set -a; . ./.env; set +a
echo "4/4 In Claude Code registrieren"
claude mcp remove etsy >/dev/null 2>&1 || true
claude mcp add etsy -s user \
  -e ETSY_API_KEY="$ETSY_API_KEY" \
  -e ETSY_SHARED_SECRET="$ETSY_SHARED_SECRET" \
  -e ETSY_OAUTH_PORT="${ETSY_OAUTH_PORT:-3003}" \
  -- node "$(pwd)/dist/index.js"

echo
echo "Fertig. In Claude Code: /mcp -> etsy sollte 'Connected' zeigen."
echo "Dann einmal das Werkzeug 'authenticate' aufrufen (Browser öffnet Etsy-Login)."
