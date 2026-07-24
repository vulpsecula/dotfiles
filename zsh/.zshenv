typeset -U path fpath

export PNPM_HOME="$HOME/Library/pnpm"

path=(
  # pnpm
  "$PNPM_HOME/bin"

  # User tools
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"

  # Editor tooling
  "$HOME/.local/share/nvim/mason/bin"

  $path
)

# Added for Claude Code LSP
export ENABLE_LSP_TOOL=1
