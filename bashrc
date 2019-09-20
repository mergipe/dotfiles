#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah'
alias l='ls -lah --group-directories-first'

export PS1="\[$(tput bold)\]\u@\h:\w\\$ \[$(tput sgr0)\]"
