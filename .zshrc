# mise
export PATH="$HOME/.local/bin:$PATH"

if [[ -n ${WSL_DISTRO_NAME:-} && ",${MISE_ENV:-}," != *,wsl,* ]]; then
  export MISE_ENV="wsl${MISE_ENV:+,$MISE_ENV}"
fi

eval "$(mise activate zsh)"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Completion
autoload -Uz compinit
compinit

# Autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Prompt
eval "$(starship init zsh)"

# Keep syntax highlighting last so it can wrap ZLE widgets correctly.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



####
# Epic aliases and functions (optional)
#

_codex_is_epic_workspace() {
  [[ "$PWD" == "$HOME/dev/epic" || "$PWD" == "$HOME/dev/epic/"* ]]
}

# Route automatically by directory; the explicit Epic commands work anywhere.
# `env` launches the external binary rather than recursively calling a function.
codex() {
  if _codex_is_epic_workspace; then
    codex-epic "$@"
    return $?
  fi

  # Pane hooks need a backend that inherits this tmux pane's environment.
  if [[ -n ${TMUX:-} ]] && (( ${argv[(Ie)--no-daemon]} == 0 )); then
    set -- --no-daemon "$@"
  fi

  command env \
    -u CLAUDE_GATEWAY_CODEX_USER_CONFIG_FILE \
    CODEX_HOME="$HOME/.codex" \
    CODEX_SQLITE_HOME="$HOME/.codex" \
    codex "$@"
}

codex-epic() {
  if [[ ! -f $HOME/.codex-epic/config.toml || ! -f $HOME/.codex-epic/claude-gateway.json ]]; then
    print -u2 "Epic Codex is not configured. Run: epic-ai-setup"
    return 1
  fi

  if [[ -n ${TMUX:-} ]] && (( ${argv[(Ie)--no-daemon]} == 0 )); then
    set -- --no-daemon "$@"
  fi

  command env \
    -u OPENAI_API_KEY \
    -u CODEX_API_KEY \
    -u CODEX_ACCESS_TOKEN \
    -u CLAUDE_GATEWAY_CONFIG_OVERRIDES \
    CODEX_HOME="$HOME/.codex-epic" \
    CODEX_SQLITE_HOME="$HOME/.codex-epic" \
    CLAUDE_CONFIG_DIR="$HOME/.claude-epic" \
    CLAUDE_GATEWAY_USER_CONFIG_FILE="$HOME/.claude-epic/gateway-helper-config.json" \
    CLAUDE_GATEWAY_CODEX_USER_CONFIG_FILE="$HOME/.codex-epic/claude-gateway.json" \
    codex "$@"
}

# Strip inherited provider/auth overrides for both profiles. Each profile
# supplies its own credentials and provider settings from disk.
_claude_with_home() {
  local config_dir=$1
  shift
  command env \
    -u ANTHROPIC_API_KEY \
    -u ANTHROPIC_AUTH_TOKEN \
    -u ANTHROPIC_BASE_URL \
    -u ANTHROPIC_CUSTOM_HEADERS \
    -u ANTHROPIC_PROFILE \
    -u CLAUDE_CODE_OAUTH_TOKEN \
    -u CLAUDE_CODE_OAUTH_REFRESH_TOKEN \
    -u CLAUDE_CODE_OAUTH_SCOPES \
    -u CLAUDE_CODE_USE_BEDROCK \
    -u CLAUDE_CODE_USE_VERTEX \
    -u CLAUDE_CODE_USE_FOUNDRY \
    -u CLAUDE_GATEWAY_USER_CONFIG_FILE \
    -u CLAUDE_GATEWAY_CODEX_USER_CONFIG_FILE \
    -u CLAUDE_GATEWAY_CONFIG_OVERRIDES \
    CLAUDE_CONFIG_DIR="$config_dir" \
    claude "$@"
}

claude() {
  if _codex_is_epic_workspace; then
    claude-epic "$@"
  else
    _claude_with_home "$HOME/.claude" "$@"
  fi
}

claude-epic() {
  _claude_with_home "$HOME/.claude-epic" "$@"
}

####
# aliases and functions
#

alias k='kubectl'
alias t="$HOME/.config/tmux/project"

# Load local AKS credentials alongside the Twingate-managed kubeconfig.
export KUBECONFIG="$HOME/.kube/osirion.yaml:$HOME/.kube/config"
