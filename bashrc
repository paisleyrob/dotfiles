#!/bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

unalias -a
alias ll='ls -Al --color=auto'
set -o vi

HISTCONTROL=ignoredups
LANG=C
if command -v vim >/dev/null; then
	EDITOR="vim"
	alias vi=vim
else
	EDITOR="vi"
fi
PAGER=less

prompt='$'
hostname="$(hostname -s)"
if [ "$(id -u)" -eq 0 ]; then
	pclr=31
	prompt='#'
else
	pclr=32
fi

if command -v gpgconf >/dev/null; then
	SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
	export SSH_AUTH_SOCK
fi

# Bash specific section
if [ -n "$BASH" ]; then
	PS1="\[\e[0;${pclr}m\]\u@${hostname} \[\e[1;34m\]\W {\!}${prompt} \[\e[0m\]"
	shopt -s checkwinsize
	complete -r
	unset -f command_not_found_handle
else
	PS1="${USER}@${hostname} ${prompt} "
fi

unset hostname pclr prompt

export HISTCONTROL
export PS1
export LANG
export EDITOR
export PAGER
