#!/bin/bash

# Check if the script is being run as root, if so, exit with a message
if [ "$(id -u)" -eq 0 ]; then
  echo "This script should not be run as root. Please run as a normal user."
  exit 1
fi

# Step 1: Install prerequisites
echo "Installing dependencies..."
sudo apt update && sudo apt install -y \
    wget \
    curl \
    unzip \
    jq \
    fonts-powerline \
    git \
    build-essential \
    cmake \
    libasound2-dev \
    libpulse-dev \
    libsdl2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libmpdclient-dev \
    libglib2.0-dev \
    libssl-dev

# Step 2: Install Oh My Posh
echo "Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash

# Step 3: Add Oh My Posh initialization to shell profile (bash example)
echo "Setting up Oh My Posh in the shell profile..."

# Detect shell type
SHELL_PROFILE="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [ -n "$FISH_VERSION" ]; then
    SHELL_PROFILE="$HOME/.config/fish/config.fish"
fi

# Add Oh My Posh setup to profile
echo 'if command -v oh-my-posh &>/dev/null; then' >> "$SHELL_PROFILE"
echo '    eval "$(oh-my-posh init bash --config ~/themes/cobalt2.omp.json)"' >> "$SHELL_PROFILE"
echo 'fi' >> "$SHELL_PROFILE"

# Step 4: Download the Cobalt 2 theme
echo "Downloading the Cobalt 2 theme..."
mkdir -p ~/themes
curl -o ~/themes/cobalt2.omp.json https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/cobalt2.omp.json

# Step 5: Install Fastfetch
echo "Installing Fastfetch..."
git clone https://github.com/FelixKratz/fastfetch.git ~/fastfetch
cd ~/fastfetch || exit
make
sudo make install

# Step 6: Install Yazi
echo "Installing Yazi..."
git clone https://github.com/muennich/yazi.git ~/yazi
cd ~/yazi || exit
make
sudo make install

# Step 7: Install Cava
echo "Installing Cava..."
git clone https://github.com/karlstav/cava.git ~/cava
cd ~/cava || exit
make
sudo make install

# Step 8: Apply changes by reloading the profile
echo "Applying changes. Please restart your terminal or run 'source $SHELL_PROFILE' to apply."
source "$SHELL_PROFILE"

echo "Oh My Posh with the Cobalt 2 theme, Fastfetch, Yazi, and Cava have been installed successfully!"
