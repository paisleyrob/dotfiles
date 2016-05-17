# vim:sw=2
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

unalias -a
alias ll='ls -Al'
set -o vi

HISTCONTROL=ignoredups
LANG=C
if which vim > /dev/null 2>&1; then
  EDITOR=vim
  alias vi=vim
else
  EDITOR=vi
fi
PAGER=less

prompt='$'
if [ `id -u` -eq 0 ]; then
  pclr=31
  prompt='#'
fi

if [ -r /etc/debian_chroot ]; then
  hostname="`cat /etc/debian_chroot`"
  pclr=33
elif which zonename > /dev/null 2>&1; then
  hostname="`hostname`"
  zone="`zonename`"
  if [ "$zone" != global ]; then
    hostname="$hostname[$zone]"
    pclr=${pclr:=33}
  fi
  pclr=${pclr:=32}
else
  hostname="`hostname -s`"
  pclr=${pclr:=32}
fi

# Bash specific section
if [ ! -z "$BASH" ]; then
  PS1="\[\e[0;${pclr}m\]\u@${hostname} \[\e[1;34m\]\W {\!}${prompt} \[\e[0m\]"
  shopt -s checkwinsize
  complete -r
  unset -f command_not_found_handle
else
  PS1="${USER}@${hostname} ${prompt} "
fi

unset hostname pclr prompt zone

export HISTCONTROL
export PS1
export LANG
export EDITOR
export PAGER
