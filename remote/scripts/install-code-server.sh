#!/usr/bin/env bash
# Install a pinned code-server release and verify the upstream checksum.

set -euo pipefail

# Keep the release and digests together. GitHub's release API publishes these
# digests, while code-server does not ship a separate .deb.sha256 asset.
CODE_SERVER_VERSION="${CODE_SERVER_VERSION:-4.130.0}"
CODE_SERVER_AMD64_SHA256="2df0f7718a1e6ac090fa39226c1a291453403e3ca2e636804695648cdb24a851"
CODE_SERVER_ARM64_SHA256="2ff0ca6d6696be06ce2e0d28c6dd0158383a40a6319af459c5d4dec910e5c131"
INSTALL_DIR="${PLAYGROUND_INSTALL_DIR:-/tmp/playground-install}"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "ERROR: install-code-server.sh must run as root (as it does in Google Colab)." >&2
  exit 1
fi

installed_version=""
if command -v code-server >/dev/null 2>&1; then
  installed_version="$(code-server --version | head -n 1)"
fi

if [[ "$installed_version" == "$CODE_SERVER_VERSION" ]]; then
  echo "==> code-server ${CODE_SERVER_VERSION} is already installed"
  exit 0
fi

architecture="$(dpkg --print-architecture)"
case "$architecture" in
  amd64)
    expected_sha256="$CODE_SERVER_AMD64_SHA256"
    ;;
  arm64)
    expected_sha256="$CODE_SERVER_ARM64_SHA256"
    ;;
  *)
    echo "ERROR: code-server ${CODE_SERVER_VERSION} is not configured for Debian architecture: ${architecture}" >&2
    exit 1
    ;;
esac

mkdir -p "$INSTALL_DIR"
package_path="${INSTALL_DIR}/code-server_${CODE_SERVER_VERSION}_${architecture}.deb"
release_url="https://github.com/coder/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_${architecture}.deb"

echo "==> Installing code-server ${CODE_SERVER_VERSION} for ${architecture}"
curl --fail --show-error --location --retry 3 --retry-all-errors \
  --output "$package_path" "$release_url"
printf '%s  %s\n' "$expected_sha256" "$package_path" | sha256sum --check

dpkg -i "$package_path"
rm -f "$package_path"

actual_version="$(code-server --version | head -n 1)"
if [[ "$actual_version" != "$CODE_SERVER_VERSION" ]]; then
  echo "ERROR: expected code-server ${CODE_SERVER_VERSION}, found ${actual_version:-nothing}." >&2
  exit 1
fi

echo "==> code-server ${actual_version} installed successfully"
