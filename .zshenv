export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export EDITOR=$(which nvim)
export XDG_CONFIG_HOME="$HOME/.config"

typeset -U path PATH

path=(
	/usr/sbin
	/usr/local/go/bin
	$path
)

[[ -f "$CARGO_HOME/env" ]] && . "$CARGO_HOME/env"
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

