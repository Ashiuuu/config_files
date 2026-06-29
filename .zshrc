# ==============================================================================
# 1. SYSTEM OPTION CONFIGURATIONS
# ==============================================================================
setopt autocd              # change directory just by typing its name
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word
PROMPT_EOL_MARK=""         # hide EOL sign ('%')

# ==============================================================================
# 2. KEY BINDINGS (Emacs Style)
# ==============================================================================
bindkey -e
bindkey ' ' magic-space                           # history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# ==============================================================================
# 3. PIMPED COMPLETIONS & COLOURED MAN PAGES
# ==============================================================================
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

# Visual configuration for Tab completion menus
zstyle ':completion:*:*:*:*:*' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 
zstyle ':completion:*:messages' format '%F{141}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{196}── no matches found ──%f'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Modernized Styling for Less / Man pages (Catppuccin-esque)
export LESS_TERMCAP_mb=$'\E[01;31m'   # blink
export LESS_TERMCAP_md=$'\E[01;141m'  # headers: Gorgeous Lavender
export LESS_TERMCAP_me=$'\E[0m'       
export LESS_TERMCAP_so=$'\E[01;240;220m' # search targets: gold background
export LESS_TERMCAP_se=$'\E[0m'       
export LESS_TERMCAP_us=$'\E[01;081m'  # underlines: Sky blue
export LESS_TERMCAP_ue=$'\E[0m'       

# ==============================================================================
# 4. HISTORY CONFIGURATIONS
# ==============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first 
setopt hist_ignore_dups       
setopt hist_ignore_space      
setopt hist_verify            

TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ==============================================================================
# 5. ENVIRONMENT VARIABLES & PATHS
# ==============================================================================
export PATH="$PATH:$HOME/.local/bin/:/usr/sbin/:/usr/local/go/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/"
export EDITOR=$(which nvim)

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local environment profiles
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ==============================================================================
# 6. ALIASES & FUNCTIONS
# ==============================================================================
alias history="history 0"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias lla='ls -lah'
alias ll='ls -lh'
alias la='ls -Ah'
alias l='ls -CFh'

alias shcheck='shcheck.py'

if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

function swap()
{
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: swap file1 file2"
        return 1
    fi
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

# ==============================================================================
# 7. CYBERPUNK / MINIMALIST GEOMETRIC PROMPT
# ==============================================================================
autoload -Uz vcs_info
precmd_functions+=(vcs_info)

# Live Git tracking segments
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{196}●%f'  # Unstaged modifications
zstyle ':vcs_info:*' stagedstr '%F{046}●%f'    # Staged additions
zstyle ':vcs_info:git:*' formats '%F{242}on%f %F{211} %b%c%u%f '

# VirtualEnv layout
VIRTUAL_ENV_DISABLE_PROMPT=1
venv_info() {
    [ -n "$VIRTUAL_ENV" ] && echo "%F{221}(${VIRTUAL_ENV:t}) %f"
}

# Window Title
case "$TERM" in
    xterm*|rxvt*|terminator*)
        TERM_TITLE=$'\e]0;%n@%m: %~\a'
        ;;
esac

precmd() {
    print -Pnr -- "$TERM_TITLE"
    print "" # Generates clean spatial breathing room between commands
}

# Rounded elegant geometric frame configuration
# Line 1: ╭─ [User] in [Directory] [Git Status]
# Line 2: ╰─ ❯ [Command Entry]
PROMPT='%F{239}╭─%f %F{141}%n%f %F{242}in%f %B%F{081}%~%f%b $(venv_info)${vcs_info_msg_0_}
%F{239}╰─%f %(?.%F{045}❯.%F{196}❯)%f '

# Clean Right Prompt tracking background processes and execution timestamp
RPROMPT='%(?..%F{196}%? ⨯ %f)%(1j.%F{220}%j ⚙ %f.)%F{241}%*%f'

# ==============================================================================
# 8. EXTERNAL PLUGINS (Sourced last to prevent interference)
# ==============================================================================
# Auto-suggestions
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=196,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=141,bold
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=045,bold
    ZSH_HIGHLIGHT_STYLES[path]=underline,fg=081
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=221
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=221
    ZSH_HIGHLIGHT_STYLES[comment]=fg=242,italic
fi
