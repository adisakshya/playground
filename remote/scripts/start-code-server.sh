#!/usr/bin/env bash
# Start code-server on the Colab loopback interface and wait for its health endpoint.

set -euo pipefail

PORT="${CODE_SERVER_PORT:-8000}"
WORKSPACE_DIR="${PLAYGROUND_WORKSPACE_DIR:-/content/workspace}"
LOG_DIR="${PLAYGROUND_LOG_DIR:-/content/playground-logs}"
PID_FILE="${LOG_DIR}/code-server.pid"

if [[ -z "${CODE_SERVER_PASSWORD:-}" ]]; then
  echo "ERROR: CODE_SERVER_PASSWORD must be set before starting code-server." >&2
  exit 1
fi

mkdir -p "$WORKSPACE_DIR" "$LOG_DIR"

if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "==> code-server is already running (PID $(cat "$PID_FILE"))"
else
  rm -f "$PID_FILE"
  echo "==> Starting code-server on 127.0.0.1:${PORT}"
  nohup env PASSWORD="$CODE_SERVER_PASSWORD" \
    code-server --auth password --bind-addr "127.0.0.1:${PORT}" "$WORKSPACE_DIR" \
    >"${LOG_DIR}/code-server.out" 2>"${LOG_DIR}/code-server.err" < /dev/null &
  echo "$!" > "$PID_FILE"
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
"${script_dir}/check-code-server.sh"
