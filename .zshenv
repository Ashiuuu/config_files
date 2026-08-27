export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export PATH="$PATH:/usr/local/go/bin"
export EDITOR=$(which nvim)
export XDG_CONFIG_HOME='/home/cmi/.config'

# Antigravity CLI
export PATH="/usr/sbin:$PATH"

. "$CARGO_HOME/env"
. "$HOME/.local/bin/env"

typeset -U path

