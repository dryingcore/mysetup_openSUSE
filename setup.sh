#!/bin/bash

# Close if any command fails
set -e

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
if ! command -v git &> /dev/null; then
    echo "Installing Git..."
    sudo zypper install -y git
    echo "Boss, Git installed! Don't forget to 'git config --global user.email \"\"' and 'git config --global user.name \"\"'"
else
    echo "Git is already installed."
fi

# Install ZSH and Oh My ZSH
if ! command -v zsh &> /dev/null; then
    echo "Installing ZSH and Oh My ZSH..."
    sudo zypper install -y zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "ZSH is already installed."
fi

# Define ZSH as default shell
chsh -s $(which zsh)

# Install ZSH plugins
echo "Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Add plugins to .zshrc
echo "Configuring plugins in .zshrc..."
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# Install ZSH theme
echo "Installing ZSH theme..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="power"/' ~/.zshrc

# Add custom Powerlevel10k settings to .zshrc
echo "Adding custom Powerlevel10k settings..."
cat <<EOL >> ~/.zshrc

# Custom Powerlevel10k settings
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}┌──%f"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}└─>%f "
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S}"

# Command aliases
alias ll='ls -la'
alias gs='git status'
alias gcm='git commit -m'

# Export environment variables
export EDITOR='nano'  # Define default editor
export PATH="$HOME/bin:$PATH"  # Add bin folder to PATH

# History settings
HISTSIZE=10000  # Max commands in history
SAVEHIST=10000  # Max commands to keep in history
HISTFILE=~/.zsh_history  # History file

EOL

# Reload ZSH
echo "Reloading ZSH configuration..."
source ~/.zshrc

echo "Setup complete! Don't forget to logout and login again to switch to ZSH."
