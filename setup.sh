#!/bin/sh
set -e

SCRIPT=`readlink -f "$0" 2> /dev/null || echo "${PWD}/$0"`
SCRIPT_DIR=`dirname "$SCRIPT"`
TPUT=`command -v tput`
FILES="Xmodmap bashrc profile ratpoisonrc screenrc tmux.conf vim vimrc"
EXECUTABLES="acpi ratpoison screen st stow vim wmname xset xsetroot xterm xtrlock"

if [ "${PWD}" != "${HOME}" ]; then
    echo "WARNING: This script is meant to be run from your home directory, but you have run it from ${PWD}." | fmt
    echo
    read -p "Press [Ctrl-C] to quit or [Enter] to ignore this warning... " throwaway
fi

colorize() {
    if [ ! -z "${TPUT}" ]; then
        tput "$@" 2> /dev/null
    fi
}

linkfile() {
    link_name="${PWD}/.`basename $1`"
    target=`relpath "${SCRIPT_DIR}/${1}" "${PWD}"`

    if [ -e "${link_name}" -o -h "${link_name}" ]; then
        if [ "`readlink ${link_name}`" != "$target" ]; then
            echo "`colorize setaf 1`WARNING: ${link_name} exists, but is not a symbolic link to ${target}`colorize sgr0`"
        fi
    else
        printf "Linking %-55s" "${link_name} -> ${target}..."
        link_out=`ln -s "${target}" "${link_name}" 2>&1`
        if [ 0 -eq $? ]; then
            echo "`colorize setaf 2`success`colorize sgr0`"
        else
            echo "`colorize setaf 1`failure`colorize sgr0`"
            echo $link_out
        fi
    fi
}

relpath() {
    if command -v python > /dev/null; then
        python -c "import os.path; print(os.path.relpath('$1','$2'))"
    else
        # Some versions of /bin/sh won't substitute on $1/$2 arguments
        _b="$1"
        _r="$2"
        echo ${_b##${_r}/}
    fi
}

for exe in ${EXECUTABLES}; do
    printf "Validating presence of %-40s" "${exe} ..."
    location=`command -v ${exe}` || :
    if [ ! -z "$location" ]; then
        printf "%s%s%s\n" "`colorize setaf 2`" "$location" "`colorize sgr0`"
    else
        echo "`colorize setaf 1`not found`colorize sgr0`"
    fi
done

for file in ${FILES}; do
    linkfile "$file"
done

# vim:tabstop=4:shiftwidth=4:expandtab
