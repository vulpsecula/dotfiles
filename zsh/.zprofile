# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  [[ -d /opt/homebrew/opt/openjdk/bin ]] && path=(/opt/homebrew/opt/openjdk/bin $path)
  [[ -d /opt/homebrew/opt/rustup/bin ]] && path=(/opt/homebrew/opt/rustup/bin $path)
  export HOMEBREW_AUTO_UPDATE_SECS="86400"
else
  print -u2 "homebrew: /opt/homebrew/bin/brew is unavailable; setup skipped"
fi

# Added by Toolbox App
[[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]] &&
  path+=("$HOME/Library/Application Support/JetBrains/Toolbox/scripts")

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
[[ -r "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"

# Optional application paths
[[ -d "$HOME/.lmstudio/bin" ]] && path+=("$HOME/.lmstudio/bin")
[[ -d "$HOME/.antigravity-ide/antigravity-ide/bin" ]] &&
  path=("$HOME/.antigravity-ide/antigravity-ide/bin" $path)
