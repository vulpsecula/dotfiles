# Dotfiles

## Installation

You may need to backup your original dotfiles before the installation.

```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Clone the repository to home directory
git clone https://github.com/Dzx1025/dotfiles.git
# Optional, you may choose other package manger
brew bundle
# choose the configuration you want to install
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

Installed automatically by the zsh configuration:

- zinit
- powerlevel10k
- zsh-completions
- fzf-tab
- zsh-autosuggestions
- zsh-syntax-highlighting

Installed by `brew bundle`:

Required by shell startup:

- fzf
- zoxide

Shell enhancements:

- eza
- fd

Dev tools:

- awscli
- openjdk
- pnpm

Prompt font:

- MesloLG Nerd Font

Register Homebrew OpenJDK with the macOS Java wrappers after its first install:

```bash
sudo ln -sfn $HOMEBREW_PREFIX/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
```

### Zsh maintenance

- Zinit plugins follow their upstream default branches. Update them explicitly and
  then verify the prompt, Tab completion, fzf and zoxide integration:

  ```bash
  zinit self-update
  zinit update --parallel
  ```

- Commands prefixed with a space are excluded from zsh history by
  `hist_ignore_space`. Use this for commands that temporarily contain  secrets.

### Tmux

```bash
# install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install Catppuccin manually to avoid TPM plugin name conflicts
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone --branch v2.3.0 --depth 1 https://github.com/catppuccin/tmux.git \
  ~/.config/tmux/plugins/catppuccin/tmux

stow tmux
```

After starting tmux, manage TPM plugins with the configured `Ctrl-a` prefix:

- `Ctrl-a I` installs missing plugins.
- `Ctrl-a U` updates installed plugins.
- `Ctrl-a Alt-u` removes plugins no longer declared in `.tmux.conf`.

The equivalent commands are useful during non-interactive VPS setup:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all
~/.tmux/plugins/tpm/bin/clean_plugins
```
