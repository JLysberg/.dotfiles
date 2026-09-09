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

# Keep personal and Epic authentication, sessions, memories, plugins, and
# SQLite-backed state in separate Codex homes. `env` launches the external
# binary rather than recursively calling this function.
codex() {
  if _codex_is_epic_workspace; then
    if [[ ! -f $HOME/.codex-epic/config.toml || ! -f $HOME/.codex-epic/claude-gateway.json ]]; then
      print -u2 "Epic Codex is not configured. Run: epic_codex_gateway setup"
      return 1
    fi

    command env \
      -u OPENAI_API_KEY \
      -u CODEX_API_KEY \
      -u CODEX_ACCESS_TOKEN \
      CODEX_HOME="$HOME/.codex-epic" \
      CODEX_SQLITE_HOME="$HOME/.codex-epic" \
      CLAUDE_GATEWAY_CODEX_USER_CONFIG_FILE="$HOME/.codex-epic/claude-gateway.json" \
      codex "$@"
  else
    command env \
      -u CLAUDE_GATEWAY_CODEX_USER_CONFIG_FILE \
      CODEX_HOME="$HOME/.codex" \
      CODEX_SQLITE_HOME="$HOME/.codex" \
      codex "$@"
  fi
}

####
# aliases and functions
#

alias k='kubectl'
alias t="$HOME/.config/tmux/project"
