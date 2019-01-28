if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#source /usr/share/fzf/completion.zsh
#source /usr/share/fzf/key-bindings.zsh

export PATH="$PATH:/bin:/home/simon/dotfiles/bin"
export PATH
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export EDITOR="nvim"
export VISUAL="nvim"
export SHELL="/bin/zsh"

export ANDROID_HOME='/usr/local/Caskroom/android-sdk/3859397,26.0.2'

alias vim="nvim"

# Locale fixes for OS X...
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
