# =============================================================================
# POWERLEVEL10K INSTANT PROMPT
# =============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# PLUGIN MANAGER BOOTSTRAP
# =============================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  if (( $+commands[git] )); then
    mkdir -p "${ZINIT_HOME:h}"
    if ! command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
      print -u2 "zinit: failed to clone"
      return 1
    fi
  else
    print -u2 "zinit: git is unavailable"
    return 1
  fi
fi
if ! source "$ZINIT_HOME/zinit.zsh"; then
  print -u2 "zinit: failed to initialize"
  return 1
fi

# =============================================================================
# PLUGINS: EARLY LOAD
# =============================================================================

# Prompt
zinit ice depth=1
zinit light romkatv/Powerlevel10k

# Completion definitions must be available before compinit.
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# =============================================================================
# COMPLETION INITIALIZATION
# =============================================================================

# Docker CLI completions must be on fpath before compinit.
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

autoload -Uz compinit

# Run a full completion audit once per day; reuse the dump otherwise.
() {
  setopt local_options extended_glob
  local zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
  local -a stale_dump

  if [[ ! -d "${zcompdump:h}" ]] && ! command mkdir -p -m 700 "${zcompdump:h}"; then
    print -u2 "zsh: cannot create XDG completion cache; using ~/.zcompdump"
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  fi

  stale_dump=( $zcompdump(#qN.mh+24) )
  if (( ${#stale_dump} )); then
    compinit -d "$zcompdump" && command touch "$zcompdump"
  else
    compinit -C -d "$zcompdump"
  fi
}

# =============================================================================
# INTERACTIVE OPTIONS AND KEYBINDINGS
# =============================================================================

setopt interactive_comments

# Select the final keymap before fzf and plugin widgets are bound.
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# =============================================================================
# FZF INTEGRATION
# =============================================================================

if (( $+commands[fzf] )); then
  # Use fd for standalone fzf, file/directory selection, and directory changes.
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND='fd --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
  fi

  # Load fzf's Tab widget before fzf-tab so fzf-tab can wrap it.
  source <(fzf --zsh)
else
  print -u2 "fzf: command is unavailable; integration disabled"
fi

# =============================================================================
# PLUGINS: POST-COMPINIT LOAD AND CONFIGURATION
# =============================================================================

# Skip autosuggestion work for large pasted or edited buffers.
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Replay completion definitions before loading fzf-tab.
zinit cdreplay -q

# Completion widget
if (( $+commands[fzf] )); then
  zinit light Aloxaf/fzf-tab
fi

# Deferred interactive plugins
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# Prompt configuration; customize with `p10k configure` or ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# COMPLETION BEHAVIOR AND APPEARANCE
# =============================================================================

# Zsh completion behavior
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Preserve Git's checkout ordering.
zstyle ':completion:*:git-checkout:*' sort false

# Plain descriptions enable groups; fzf-tab ignores escape sequences here.
zstyle ':completion:*:descriptions' format '[%d]'

# Let fzf-tab capture the unambiguous prefix instead of Zsh's menu.
zstyle ':completion:*' menu no

# fzf-tab behavior

# Preview directory contents with eza when available.
if (( $+commands[eza] )); then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza -1 --icons -a --group-directories-first --git --color=always $realpath'
fi

# Switch completion groups with `<` and `>`.
zstyle ':fzf-tab:*' switch-group '<' '>'

# fzf theme

# Detect the current desktop theme once while configuring fzf.
is-dark-mode() {
  if [[ "$OSTYPE" == darwin* ]]; then
    defaults read -globalDomain AppleInterfaceStyle &> /dev/null
    return
  fi

  if [[ "$OSTYPE" == linux* ]]; then
    local scheme
    scheme="$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)"
    [[ "$scheme" == *prefer-dark* ]] && return 0
    [[ "$scheme" == *prefer-light* ]] && return 1
  fi

  if [[ "${COLORFGBG:-}" == *';'* ]]; then
    local background="${COLORFGBG##*;}"
    if [[ "$background" == <-> ]] && (( background <= 15 )); then
      (( background <= 6 || background == 8 )) && return 0
      return 1
    fi
  fi

  # Headless Linux and SSH sessions default to a dark terminal theme.
  [[ "$OSTYPE" == linux* || -n "${SSH_CONNECTION:-}" ]] && return 0
  return 1
}

if is-dark-mode; then
  # Catppuccin Mocha
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#6C7086,label:#CDD6F4"
else
  # Catppuccin Latte
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
    --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
    --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
    --color=selected-bg:#BCC0CC \
    --color=border:#9CA0B0,label:#4C4F69"
fi
unfunction is-dark-mode

# fzf-tab ignores FZF_DEFAULT_OPTS unless explicitly enabled.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# fzf-tab interface overrides
zstyle ':fzf-tab:*' fzf-flags \
  --height=80% \

# =============================================================================
# HISTORY
# =============================================================================

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
if [[ ! -d "${HISTFILE:h}" ]] && ! command mkdir -p -m 700 "${HISTFILE:h}"; then
  print -u2 "zsh: cannot create XDG history directory; using ~/.zsh_history"
  HISTFILE="$HOME/.zsh_history"
fi

HISTSIZE=10000
SAVEHIST=10000

setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_verify

# =============================================================================
# ALIASES
# =============================================================================

alias c="clear"
if (( $+commands[eza] )); then
  alias l="eza --icons --git"
  alias ls="eza --icons --git"
  alias la="eza -a --icons --git"
  alias ll="eza -al --git"
fi
(( $+commands[aws] )) &&
  alias awslocal="AWS_PROFILE=localstack aws --endpoint-url=http://localhost:4566"

# =============================================================================
# DIRECTORY NAVIGATION
# =============================================================================

if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd=cd zsh)"
else
  print -u2 "zoxide: command is unavailable; integration disabled"
fi
