# Personal aliases and functions sourced by ~/.bashrc.

if command -v dircolors >/dev/null 2>&1; then
    if [[ -r "$HOME/.dircolors" ]]; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='grep -F --color=auto'
    alias egrep='grep -E --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Send a desktop notification after a long command: sleep 10; alert
# An interactive shell may retain the old Ubuntu `alert` alias when this file
# is reloaded. Alias expansion happens while function definitions are parsed,
# so remove it before declaring the replacement function.
unalias alert 2>/dev/null || true
alert() {
    local status=$?
    local icon=terminal
    local command_line

    if ! command -v notify-send >/dev/null 2>&1; then
        printf 'alert: notify-send is not installed\n' >&2
        return 127
    fi

    (( status == 0 )) || icon=error
    command_line=$(HISTTIMEFORMAT= history 1)
    command_line=$(sed -E 's/^[[:space:]]*[0-9]+[[:space:]]*//; s/[;&|][[:space:]]*alert[[:space:]]*$//' <<<"$command_line")

    notify-send --urgency=low -i "$icon" -- "$command_line"
    return "$status"
}