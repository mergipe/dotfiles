#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -la'

export PS1="\[$(tput bold)\]\u@\h:\w\\$ \[$(tput sgr0)\]"
