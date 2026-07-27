# Bash dotfiles

Personal Bash configuration split into focused files:

- `.bashrc` sets history behavior, completion, and loads the other fragments.
- `.bash_aliases` defines colored command aliases and the `alert` function.
- `.bash_prompt` defines the colored prompt, terminal title, and occasional heart.
- `.bash_welcome` optionally displays a stegosaurus fortune in top-level shells.

The welcome message is skipped when any of its optional programs are missing.
Set `BASH_WELCOME=0` before Bash starts (for example, in `~/.profile`) to disable
it permanently.

## Fresh Linux installation

The package names below are for Debian and Ubuntu:

    sudo apt update
    sudo apt install git bash-completion coreutils grep libnotify-bin fortune-mod cowsay lolcat

Only Git and Bash are required. `bash-completion` enables richer completion,
`libnotify-bin` supplies desktop notifications for `alert`, and the final three
packages provide the optional greeting. On another distribution, install the
equivalent packages with its package manager.

Clone the repository at the expected location:

    git clone <repository-url> "$HOME/dotfiles"

### Option A: use the repository configuration directly

Back up an existing configuration, then create a symlink:

    test ! -e "$HOME/.bashrc" || mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
    ln -s "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"

The main file resolves the other fragments relative to itself, so they do not
need separate symlinks.

### Option B: retain machine-local configuration

Keep a normal `~/.bashrc` and add this near its beginning:

    if [[ -r "$HOME/dotfiles/.bashrc" ]]; then
        source "$HOME/dotfiles/.bashrc"
    fi

Put machine-, employer-, credential-, and SDK-specific configuration after
that block. This is the recommended approach when the machine has local setup
that should not be committed. Do not source the shared configuration more than
once from the same shell startup path.

## Activate and verify

Open a new terminal, or reload the current interactive shell:

    source "$HOME/.bashrc"

Before reloading after an edit, check syntax with:

    for file in .bashrc .bash_aliases .bash_prompt .bash_welcome; do
        bash -n "$HOME/dotfiles/$file" || break
    done

Useful checks after loading are `type alert`, `alias ll`, and
`printf '%s\n' "$HISTSIZE"`. The expected history size is 50000.

## Customization

- Adjust prompt colors or heart frequency in `.bash_prompt`.
- Add portable aliases and functions to `.bash_aliases`.
- Change or remove the greeting in `.bash_welcome`.
- Keep secrets and host-specific paths outside this repository.