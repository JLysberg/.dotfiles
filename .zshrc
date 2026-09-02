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
