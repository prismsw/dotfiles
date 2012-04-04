alias ls='ls --color=auto'
alias pacman='pacman-color'
alias sudo='sudo '

export EDITOR="vim"

PS1='\[\e[0;32m\]\u@\H\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] ' 


if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
