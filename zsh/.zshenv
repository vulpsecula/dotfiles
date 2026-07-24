typeset -U path fpath

export PNPM_HOME="/Users/zeke/Library/pnpm"

path=(
  # pnpm
  "$PNPM_HOME/bin"
  "$PNPM_HOME"

  # Homebrew
  /opt/homebrew/bin
  /opt/homebrew/sbin

  # User tools
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"

  # Language toolchains
  /opt/homebrew/opt/openjdk/bin

  # Editor tooling
  "$HOME/.local/share/nvim/mason/bin"

  $path
)

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# Openjdk
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# Homebrew auto update
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# Added for Claude Code LSP
export ENABLE_LSP_TOOL=1
