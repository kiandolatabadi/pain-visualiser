#!/bin/bash
# Double-click this file in Finder to start Algora locally.
# Closing this Terminal window stops the local server.

cd "$(dirname "$0")"

PORT=8420
URL="http://localhost:${PORT}/algora.html"

if ! lsof -i tcp:"${PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Starting Algora server on port ${PORT}..."
  python3 -m http.server "${PORT}" >/dev/null 2>&1 &
  SERVER_PID=$!
  trap 'kill "${SERVER_PID}" 2>/dev/null' EXIT
  sleep 1
else
  echo "Server already running on port ${PORT}."
fi

echo "Opening ${URL}"
open -a "Google Chrome" "${URL}" 2>/dev/null || open "${URL}"

echo ""
echo "Algora is running. Keep this window open while you use the app."
echo "Close this window (or press Ctrl+C) to stop the server."

wait "${SERVER_PID}" 2>/dev/null
