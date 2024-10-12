#!/bin/bash

# Close if any command fails
set -e

echo "Reverting changes..."

# Remove Node.js and NVM
echo "Removing Node.js and NVM..."
rm -rf "$NVM_DIR"
sudo zypper remove -y nodejs
clear

# Remove Git if it was installed
if sudo zypper info git | grep -q "not installed"; then
    echo "Git was not installed by the script."
else
    echo "Removing Git..."
    sudo zypper remove -y git
fi
clear

# Remove ZSH and Oh My ZSH
if command -v zsh &> /dev/null; then
    echo "Removing ZSH and Oh My ZSH..."
    sudo zypper remove -y zsh
    rm -rf ~/.oh-my-zsh
    # Restore the default shell (bash)
    chsh -s $(which bash)
else
    echo "ZSH is not installed."
fi
clear

# Remove Powerlevel10k theme
echo "Removing Powerlevel10k theme..."
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
clear

# Remove ZSH plugins
echo "Removing ZSH plugins..."
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
rm -rf ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
clear

# Restore original .zshrc (or delete if none exists)
if [ -f ~/temp-zshrc/.zshrc ]; then
    echo "Restoring original .zshrc..."
    cp ~/temp-zshrc/.zshrc ~/
    rm -rf ~/temp-zshrc
else
    echo "No backup .zshrc found, deleting current .zshrc..."
    rm -f ~/.zshrc
fi
clear

echo "Uninstallation complete!"
