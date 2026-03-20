function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1

    local session
    session=$(sesh list | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    if [[ -z "$session" ]]; then
      zle reset-prompt
      zle -R
      return
    fi

    sesh connect $session
    zle reset-prompt
    zle -R
  }
}

zle -N sesh-sessions
bindkey -M emacs '^S' sesh-sessions
bindkey -M vicmd '^S' sesh-sessions
bindkey -M viins '^S' sesh-sessions

function kube-switch() {
  {
    exec </dev/tty
    exec <&1

    local context
    context=$(
      kubectl config get-contexts --output=name |
        fzf --height 40% --reverse --border --border-label ' k8s context ' --prompt '> '
    )

    if [[ -z "$context" ]]; then
      zle reset-prompt
      zle -R
      return
    fi

    kubectl config use-context "$context"
    zle reset-prompt
    zle -R
  }
}

zle -N kube-switch
bindkey -M emacs '^[k' kube-switch
bindkey -M vicmd '^[k' kube-switch
bindkey -M viins '^[k' kube-switch
