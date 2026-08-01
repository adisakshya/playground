#!/bin/bash
set -euo pipefail

###############################################
#  A shell script to setup your customised    #
#  minimal development-environment on Debian  #
###############################################

# Pinned deliberately. Installing whatever is newest means an upstream CLI
# change reaches users unannounced - that is how the removal of code-server's
# --port flag broke the Colab notebook. Bump this once you have tested it.
CODE_SERVER_VERSION="${CODE_SERVER_VERSION:-4.118.0}"

# Package management needs root. Escalate only when we are not already root,
# so this works both for a normal user and inside a root container.
as_root() {
    if [ "$(id -u)" -eq 0 ]
    then
        "$@"
    elif command -v sudo > /dev/null 2>&1
    then
        sudo "$@"
    else
        echo "ERROR: this script needs root privileges and sudo is unavailable." >&2
        exit 1
    fi
}

# Install required packages and tools
as_root apt-get update -y
as_root apt-get install -y \
    build-essential \
    bash \
    curl \
    nano \
    software-properties-common \
    wget

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version "$CODE_SERVER_VERSION"

# Install required extensions
extensions=(
    'github.github-vscode-theme'
    'grapecity.gc-excelviewer'
    'ms-python.python'
    'ms-toolsai.jupyter'
    'ms-vscode.cpptools'
    'ritwickdey.liveserver'
    'vscode-icons-team.vscode-icons'
)
for extension in "${extensions[@]}"
do
    # One unavailable extension should not abort the whole setup
    if ! code-server --install-extension "$extension"
    then
        echo "WARNING: could not install extension ${extension}" >&2
    fi
done

# Check installation version
code-server --version

cat <<EOF

Setup complete. Start the Web IDE with:

    code-server --bind-addr 127.0.0.1:8080

then open http://127.0.0.1:8080 in a browser.

A password was generated during installation and is stored in:

    ${HOME}/.config/code-server/config.yaml

To run it in the background instead:

    sudo systemctl enable --now code-server@\$USER

EOF
