#!/bin/bash

# Close if any command fails
set -e

# Update OpenSUSE
echo "Updating OpenSUSE..."
sudo zypper refresh
sudo zypper install -y curl
clear

# Install NVM (node version manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
clear

# Load NVM in the current shell
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
clear

# Install Node LTS
echo "Installing Node LTS..."
nvm install --lts
clear

# Install GIT
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    sudo zypper install -y git
else
    echo "Git is already installed."
fi
clear

# Install ZSH and Oh My ZSH
if ! command -v zsh &> /dev/null; then
    echo "Installing ZSH and Oh My ZSH..."
    sudo zypper install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "ZSH is already installed."
fi
clear

# Define ZSH as default shell
chsh -s $(which zsh)
clear

# Clone your .zshrc from GitHub
echo "Cloning .zshrc from GitHub..."
git clone https://github.com/dryingcore/myzsh_config ~/temp-zshrc
cp ~/temp-zshrc/.zshrc ~/
rm -rf ~/temp-zshrc
clear

# Install ZSH plugins
echo "Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
clear

# Install ZSH theme (Powerlevel10k)
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
clear

# Reload ZSH
echo "Reloading ZSH configuration..."
source ~/.zshrc
clear

echo "Setup complete! Don't forget to logout and login again to switch to ZSH."
