ZSH=/usr/share/oh-my-zsh
ZSH_THEME="robbyrussell-mod"

plugins=(
    git
    themes
)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

bindkey -v
bindkey '^R' history-incremental-search-backward
# End of lines configured by zsh-newuser-install
#
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gustavo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit

alias ls='ls --color=auto'
alias ll='ls -lah'
alias l='ls -lah --group-directories-first'

export PATH=$PATH:/home/gustavo/.local/bin:/home/gustavo/.config/vifm/vifmimg

# resolve problems with Java applications on Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1

alias vifm="~/.config/vifm/vifmimg/vifmrun ."
export VISUAL=nvim
export EDITOR=nvim
