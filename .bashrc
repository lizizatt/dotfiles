# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Ignore commands beginning with a space, consecutive duplicates, and remove
# older duplicates when a command is reused.
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=50000

# Preserve multiline commands as entered and promptly save commands from each
# terminal. Deliberately avoid `history -n` here: merging live sessions can
# make command ordering surprising.
shopt -s cmdhist lithist
_history_save() {
    history -a
}

# Add a function to PROMPT_COMMAND without discarding configuration installed
# by other tools. This string form also works on Bash versions predating
# PROMPT_COMMAND arrays.
_bashrc_add_prompt_command() {
    local command_name=$1
    local declaration
    local existing_command

    declaration=$(declare -p PROMPT_COMMAND 2>/dev/null) || declaration=
    if [[ $declaration == "declare -a "* ]]; then
        for existing_command in "${PROMPT_COMMAND[@]}"; do
            [[ $existing_command == "$command_name" ]] && return
        done
        PROMPT_COMMAND+=("$command_name")
    else
        case ";${PROMPT_COMMAND//[[:space:]]/};" in
            *";$command_name;"*) ;;
            *) PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}$command_name" ;;
        esac
    fi
}
_bashrc_add_prompt_command _history_save

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Resolve fragments beside this file. This works whether ~/.bashrc is a
# symlink to this repository or sources it from a machine-local wrapper.
_DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)

# Personal aliases and shell functions.
if [[ -r "$_DOTFILES_DIR/.bash_aliases" ]]; then
    source "$_DOTFILES_DIR/.bash_aliases"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Prompt and optional top-level-shell greeting.
if [[ -r "$_DOTFILES_DIR/.bash_prompt" ]]; then
    source "$_DOTFILES_DIR/.bash_prompt"
fi

if [[ -r "$_DOTFILES_DIR/.bash_welcome" ]]; then
    source "$_DOTFILES_DIR/.bash_welcome"
fi

unset -f _bashrc_add_prompt_command
unset _DOTFILES_DIR