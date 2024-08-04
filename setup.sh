#!/bin/bash

# Variables
PACKAGES_FILE="packages.txt"

check_command() {
  if [ $? -ne 0 ]; then
    echo "Error: $1"
    exit 1
  fi
}

# CD to home directory
cd ~

# Install yay
echo "Installing yay..."
sudo pacman -S --noconfirm --needed git base-devel
check_command "Failed to install yay dependencies"

git clone https://aur.archlinux.org/yay.git
check_command "Failed to clone yay repository"

cd yay && makepkg -si
check_command "Failed to install yay"

# Install packages
if [ -f $PACKAGES_FILE ]; then
  echo "Installing packages..."
  yay -S --noconfirm --needed - <$PACKAGES_FILE
  check_command "Failed to install packages"
else
  echo "Error: $PACKAGES_FILE not found"
  exit 1
fi

# Enable docker
echo "Enabling docker service..."
sudo systemctl enable docker.socket
check_command "Failed to enable docker.socket service"

echo "Starting docker service"
sudo systemctl start docker.socket
check_command "Failed to start docker.socket service"

# Set ZSH as default shell
echo "Setting ZSH as default shell..."
chsh -s $(which zsh)
check_command "Failed to set ZSH as default shell"

# We're done!
echo "Setup completed successfully!"
exit 0
