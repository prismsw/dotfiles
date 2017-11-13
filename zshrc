if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#source /usr/share/fzf/completion.zsh
#source /usr/share/fzf/key-bindings.zsh

PATH="$PATH:/bin:/home/simon/dotfiles/bin"
export PATH
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export EDITOR="nvim"
export VISUAL="nvim"
export SHELL="/bin/zsh"

alias vim="nvim"
