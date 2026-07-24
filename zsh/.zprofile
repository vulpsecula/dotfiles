# Homebrew paths can be moved behind system paths by macOS login startup.
path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)

# Added by Toolbox App
path=(
  $path
  "/Users/zeke/Library/Application Support/JetBrains/Toolbox/scripts"
)

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
# For local aws dev
export AWS_PROFILE=localstack
