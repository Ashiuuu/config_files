export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export EDITOR=$(which nvim)
export XDG_CONFIG_HOME="$HOME/.config"

typeset -U path PATH

path=(
	/usr/sbin
	"$HOME/.local/bin"
	"$HOME/.local/share/cargo"
	/usr/local/go/bin
	$path
)

path=($^path(N-/))
