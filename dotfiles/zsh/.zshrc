autoload -Uz compinit
compinit

setopt auto_cd
setopt interactive_comments
setopt prompt_subst

# Let Ctrl-S/Ctrl-Q reach zsh widgets instead of being used for terminal flow control.
stty -ixon

alias k="kubectl"

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

source "$HOME/.config/zsh/prompt.zsh"
source "$HOME/.config/zsh/widgets.zsh"
