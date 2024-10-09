#!/bin/bash

# Update OpenSUSE
echo "Updating OpenSUSE..."
sudo zypper refresh
sudo zypper install -y curl

# Install NVM (node version manager)
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Load NVM in the current shell
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node LTS
echo "Installing Node LTS..."
nvm install --lts

# Install GIT
echo "Installing Git..."
sudo zypper install -y git
echo "Boss, Git installed! Don't forget to 'git config --global user.email \"\"' and 'git config --global user.name \"\"'"

# Install ZSH and Oh My ZSH
echo "Installing ZSH and Oh My ZSH..."
sudo zypper install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Define ZSH as default shell
chsh -s $(which zsh)

# Install ZSH plugins
echo "Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add plugins to .zshrc
echo "Configuring plugins in .zshrc..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Install ZSH themes
echo "Installing ZSH theme..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="power"/' ~/.zshrc

# Reload ZSH
echo "Reloading ZSH configuration..."
source ~/.zshrc

echo "Setup complete!"
