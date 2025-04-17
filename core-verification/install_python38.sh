#!/bin/bash

set -e

# Define paths
INSTALL_DIR="$HOME/.local/python3.8"
SRC_DIR="$HOME/.local/python"
PYTHON_VERSION="3.8.18"
PYTHON_TGZ="Python-$PYTHON_VERSION.tgz"
PYTHON_FOLDER="Python-$PYTHON_VERSION"
PYTHON_URL="https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_TGZ"

# Create directories
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"

# Download and extract Python source
if [ ! -f "$PYTHON_TGZ" ]; then
    echo "Downloading Python $PYTHON_VERSION..."
    wget "$PYTHON_URL"
fi

echo "Extracting Python source..."
tar -xf "$PYTHON_TGZ"
cd "$PYTHON_FOLDER"

# Configure and install
echo "Configuring build..."
./configure --prefix="$INSTALL_DIR" --enable-optimizations

echo "Building (this may take a few minutes)..."
make -j"$(nproc)"

echo "Installing locally..."
make install

# Update shell config
SHELL_RC="$HOME/.bashrc"
if [[ "$SHELL" == *"zsh" ]]; then
    SHELL_RC="$HOME/.zshrc"
fi

echo "Updating PATH in $SHELL_RC..."
echo "" >> "$SHELL_RC"
echo "# Added by install_python38.sh" >> "$SHELL_RC"
echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$SHELL_RC"

# Load the updated path for current session
export PATH="$INSTALL_DIR/bin:$PATH"

# Check versions
echo "Installation complete!"
echo "Python version: $(python3.8 --version)"
echo "Pip version: $(pip3.8 --version)"

echo "✅ Please run: source $SHELL_RC"
echo "Or restart your terminal to use the new Python by default."

source ~/.bashrc