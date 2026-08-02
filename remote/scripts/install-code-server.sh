#!/usr/bin/env bash
# Install the current code-server release through its supported installer.

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: install-code-server.sh must run as root (as it does in Google Colab)." >&2
  exit 1
fi

if command -v code-server >/dev/null 2>&1; then
  echo "==> code-server $(code-server --version | head -n 1) is already installed"
  exit 0
fi

installer_path="$(mktemp)"
trap 'rm -f "$installer_path"' EXIT

echo "==> Installing the latest code-server release"
curl --fail --show-error --location --retry 3 --retry-all-errors \
  --output "$installer_path" "https://code-server.dev/install.sh"
sh "$installer_path"

if ! command -v code-server >/dev/null 2>&1; then
  echo "ERROR: the official installer completed without making code-server available on PATH." >&2
  exit 1
fi

echo "==> code-server $(code-server --version | head -n 1) installed successfully"
