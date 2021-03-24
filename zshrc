if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#source /usr/share/fzf/completion.zsh
#source /usr/share/fzf/key-bindings.zsh

export PATH="/Users/simon/dotfiles/bin_macos:/usr/local/opt/ruby@2.5/bin:/usr/local/lib/ruby/gems/2.5.0/bin:$PATH"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export EDITOR="nvim"
export VISUAL="nvim"
export SHELL="/bin/zsh"

export ANDROID_HOME='/Users/simon/Library/Android/sdk'

alias vim="nvim"

# Locale fixes for OS X...
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export HOMEBREW_NO_AUTO_UPDATE=1

PATH="/Users/simon/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/simon/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/simon/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/simon/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/simon/perl5"; export PERL_MM_OPT;
