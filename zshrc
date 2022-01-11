ZSH=/home/gustavo/.oh-my-zsh

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
HISTSIZE=1000
SAVEHIST=1000

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

export PATH=$PATH:/home/gustavo/.local/bin

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gustavo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/gustavo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/gustavo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/gustavo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


[ -s "/home/gustavo/.jabba/jabba.sh" ] && source "/home/gustavo/.jabba/jabba.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$PATH:/home/gustavo/.local/share/coursier/bin"
