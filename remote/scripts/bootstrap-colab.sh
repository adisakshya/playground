#!/usr/bin/env bash
# Prepare the minimal operating-system dependencies required by Playground.
# This script is intentionally safe to re-run in an ephemeral Colab runtime.

set -euo pipefail

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: bootstrap-colab.sh must run as root (as it does in Google Colab)." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "==> Updating package metadata"
apt-get update -y

echo "==> Installing runtime prerequisites"
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  procps

echo "==> Core prerequisites are ready"
