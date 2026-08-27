export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export EDITOR=$(which nvim)
export VISUAL=$(which nvim)
export XDG_CONFIG_HOME="$HOME/.config"
export NVM_DIR="$HOME/.config/nvm"

typeset -U path PATH

path=(
	/usr/sbin
	"$HOME/.local/bin"
	"$CARGO_HOME/bin"
	/usr/local/go/bin
	$path
)

path=($^path(N-/))
