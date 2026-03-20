autoload -Uz colors vcs_info
colors

zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{5}[%b]%f'
zstyle ':vcs_info:git:*' actionformats ' %F{5}[%b|%a]%f'

precmd() {
  vcs_info
}

PROMPT='%F{6}%1~%f${vcs_info_msg_0_} %# '
