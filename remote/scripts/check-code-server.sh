#!/usr/bin/env bash
# Confirm that the local code-server process is healthy before exposing it.

set -euo pipefail

PORT="${CODE_SERVER_PORT:-8000}"
LOG_DIR="${PLAYGROUND_LOG_DIR:-/content/playground-logs}"
PID_FILE="${LOG_DIR}/code-server.pid"

for _ in $(seq 1 30); do
  if curl --fail --silent --show-error "http://127.0.0.1:${PORT}/healthz" >/dev/null; then
    echo "==> code-server is healthy at http://127.0.0.1:${PORT}"
    exit 0
  fi

  sleep 1
done

echo "ERROR: code-server did not become healthy within 30 seconds." >&2
if [[ -f "$PID_FILE" ]]; then
  echo "PID: $(cat "$PID_FILE")" >&2
fi
if [[ -f "${LOG_DIR}/code-server.err" ]]; then
  echo "--- code-server stderr ---" >&2
  tail -n 50 "${LOG_DIR}/code-server.err" >&2
fi
exit 1
