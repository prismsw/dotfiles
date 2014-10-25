ZSH=/usr/share/oh-my-zsh
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/home/simon/bin:$PATH"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ls='ls --color=auto'

alias sudo='nocorrect noglob do_sudo '

alias mvn="color_maven"
alias maven="/usr/bin/mvn"

alias ino="nocorrect ino"

# Colorize maven output
color_maven() {
  local BOLD=`tput bold`
  local TEXT_RED=`tput setaf 1`
  local TEXT_GREEN=`tput setaf 2`
  local TEXT_YELLOW=`tput setaf 3`
  local RESET_FORMATTING=`tput sgr0`

  /usr/bin/mvn $@ | sed -e "s/\(\[INFO\]\ \-\-\-\ .*\)/${TEXT_BLUE}\1${RESET_FORMATTING}/g" \
    -e "s/\(\[INFO\]\ \[.*\)/${RESET_FORMATTING}\1${RESET_FORMATTING}/g" \
    -e "s/\(\[INFO\]\ \)\(BUILD SUCCESS\)/\1${TEXT_GREEN}\2${RESET_FORMATTING}/g" \
    -e "s/\(\[INFO\]\ \)\(BUILD FAILURE\)/\1${TEXT_RED}\2${RESET_FORMATTING}/g" \
    -e "s/\(\[WARNING\].*\)/${TEXT_YELLOW}\1${RESET_FORMATTING}/g" \
    -e "s/\(\[ERROR\]\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
    -e "s/\(Exception in thread \".*\" \)\(.*\)/\1${TEXT_RED}\2${RESET_FORMATTING}/g" \
    -e "s/\(SUCCESS \)\[/${RESET_FORMATTING}${TEXT_GREEN}\1${RESET_FORMATTING}\[/g" \
    -e "s/\(FAILURE \)\[/${RESET_FORMATTING}${TEXT_RED}\1${RESET_FORMATTING}\[/g" \
    -e "s/\(Caused by: \)\([^:\t ]*\)/\1${TEXT_RED}\2${RESET_FORMATTING}/g" \
    -e "s/\(ERROR\ \[.*\)/${TEXT_RED}\1${RESET_FORMATTING}/g" \
    -e "s/Tests run: \([^,]*\), Failures: \([^,0]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${TEXT_YELLOW}\4${RESET_FORMATTING}/g"

  echo -ne ${RESET_FORMATTING}
}


# Fixed "sudo " and nocorrect
function do_sudo
{
    integer glob=1
    local -a run
    run=( command sudo )
    if [[ $# -gt 1 && $1 = -u ]]; then
        run+=($1 $2)
        shift ; shift
    fi
    (($# == 0)) && 1=/bin/zsh
    while (($#)); do
        case "$1" in
        command|exec|-) shift; break ;;
        nocorrect) shift ;;
        noglob) glob=0; shift ;;
        *) break ;;
        esac
    done
    if ((glob)); then
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $~==*
    else
        PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $==*
    fi
}


export EDITOR="vim"
export SHELL="/bin/zsh"
PATH=$PATH:/home/simon/.gem/ruby/1.9.1/bin:/home/simon/.cabal/bin
export PATH

#{{{ ZSH Modules

autoload -U compinit promptinit zcalc zsh-mime-setup
compinit
promptinit
zsh-mime-setup
plugins=(archlinux sprunge git)
ZSH_THEME="default"

#}}}

#{{{ Options

# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
setopt CORRECT

# This makes cd=pushd
setopt AUTO_PUSHD

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# If we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS

# No more annoying pushd messages...
# setopt PUSHD_SILENT

# blank pushd goes to home
setopt PUSHD_TO_HOME

# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT

# use magic (this is default, but it can't hurt!)
setopt ZLE

setopt NO_HUP

setopt VI

# only fools wouldn't do this ;-)
export EDITOR="vim"


setopt IGNORE_EOF

# If I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL

# beeps are annoying
setopt NO_BEEP

# Keep echo "station" > station from clobbering station
setopt NO_CLOBBER

# Case insensitive globbing
setopt NO_CASE_GLOB

# Be Reasonable!
setopt NUMERIC_GLOB_SORT

# I don't know why I never set this before.
setopt EXTENDED_GLOB

# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM

#}}}

#Colour table
fg_black=%{$'\e[0;30m'%}
fg_red=%{$'\e[0;31m'%}
fg_green=%{$'\e[0;32m'%}
fg_brown=%{$'\e[0;33m'%}
fg_blue=%{$'\e[0;34m'%}
fg_purple=%{$'\e[0;35m'%}
fg_cyan=%{$'\e[0;36m'%}
fg_lgray=%{$'\e[0;37m'%}
fg_dgray=%{$'\e[1;30m'%}
fg_lred=%{$'\e[1;31m'%}
fg_lgreen=%{$'\e[1;32m'%}
fg_yellow=%{$'\e[1;33m'%}
fg_lblue=%{$'\e[1;34m'%}
fg_pink=%{$'\e[1;35m'%}
fg_lcyan=%{$'\e[1;36m'%}
fg_white=%{$'\e[1;37m'%}
#Text Background Colors
bg_red=%{$'\e[0;41m'%}
bg_green=%{$'\e[0;42m'%}
bg_brown=%{$'\e[0;43m'%}
bg_blue=%{$'\e[0;44m'%}
bg_purple=%{$'\e[0;45m'%}
bg_cyan=%{$'\e[0;46m'%}
bg_gray=%{$'\e[0;47m'%}
#Attributes
at_normal=%{$'\e[0m'%}
at_bold=%{$'\e[1m'%}
at_italics=%{$'\e[3m'%}
at_underl=%{$'\e[4m'%}
at_blink=%{$'\e[5m'%}
at_outline=%{$'\e[6m'%}
at_reverse=%{$'\e[7m'%}
at_nondisp=%{$'\e[8m'%}
at_strike=%{$'\e[9m'%}
at_boldoff=%{$'\e[22m'%}
at_italicsoff=%{$'\e[23m'%}
at_underloff=%{$'\e[24m'%}
at_blinkoff=%{$'\e[25m'%}
at_reverseoff=%{$'\e[27m'%}
at_strikeoff=%{$'\e[29m'%}
#Reset
reset_color=%{$reset_color%}
 
PROMPT="${fg_green}%n@%m${fg_white} ${fg_lblue}%~${reset_color} $ "

bindkey -e
