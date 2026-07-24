# Dotfiles

## Installation

You may need to backup your original dotfiles before the installation.

```bash
# Install Homebrew first (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Using stow to sync dotfiles
brew install stow
# Clone
git clone https://github.com/Dzx1025/dotfiles.git
# Run stow commands at the git root dir
cd dotfiles
```

## Usage

### Neovim

```bash
stow neovim
```

### Zsh

```bash
stow zsh
```

Will be installed automatically:

- zinit
- powerlevel10k (MesloLGS Nerd Font Mono)
- zsh-syntax-highlighting
- zsh-completions
- zsh-autosuggestions
- fzf-tab

Need to install manually:
- eza
- fzf
- bat
- zoxide
- MesloLGS Nerd Font Mono (required for Powerlevel10k prompt rendering)

### Tmux

```bash
# install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
stow tmux
```
