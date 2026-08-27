export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export EDITOR=$(which nvim)
export XDG_CONFIG_HOME="$HOME/.config"

typeset -U path PATH

path=(
	/usr/sbin
	"$HOME/.local/bin"
	$path
)

[[ -d "$HOME/.local/share/cargo" ]] && export CARGO_HOME="$HOME/.local/share/cargo" && path=("$CARGO_HOME/bin",$path)
[[ -d "/usr/local/go/bin" ]] && path=(/usr/local/go/bin, $path)

