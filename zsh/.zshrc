# Exports
export GPG_TTY=$(tty)
export PATH="/home/tmeister/.config/herd-lite/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/tmeister/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export EZA_ICON_SPACING=2
export EZA_ICONS_AUTO=true 

# ZINIT automatic install (Plugin Manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download ZINIT, if neeeded
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Source it! 
source "${ZINIT_HOME}/zinit.zsh"

# Plugins 
##  Completion
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit

## General plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Snippets
zinit snippet OMZP::git
zinit snippet OMZP::archlinux
zinit snippet OMZP::composer
zinit snippet OMZP::eza

zinit cdreplay -q

# Oh My Posh - Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.json)"

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

HISTSIZE=10000
HISTFILE=~/.zsh_history
HISTDUP=erase
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups 
setopt hist_find_no_dups 

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# aliases
alias c="clear"
alias e="exit"
alias l="ll"
alias t="tmux"
alias lh="ls -lh"
alias pw="~/.dotfiles/scripts/tmux-sessionizer"
alias vim="nvim"
alias nah!="git reset --hard HEAD"
alias lg="lazygit"
alias ndots="nvim ~/.dotfiles"
alias dots="cd ~/.dotfiles"

# Git 
alias gcq="git checkout qa"

# DDEV Laravel Aliases
alias a="ddev php artisan"
alias am="ddev php artisan migrate"
alias amf="ddev php artisan migrate:fresh"
alias ams="ddev php artisan migrate:fresh --seed"
alias at="ddev php artisan test"
alias ac="ddev php artisan cache:clear"
alias tinker="ddev php artisan tinker"
alias pint="ddev exec vendor/bin/pint"
alias pest="ddev exec vendor/bin/pest"
alias dco="ddev composer"
alias drun="ddev composer run"
alias dnpm="ddev npm run"
alias dssh="ddev ssh"
alias dlogs="ddev logs -f"

# Helpers
function take() {
  mkdir -p "$1" && cd "$1"
}

open() {
    nohup xdg-open "$@" >/dev/null 2>&1 &
}

# Fzf
eval "$(fzf --zsh)"

# Mise 
eval "$(mise activate zsh)"

# pnpm
export PNPM_HOME="/home/tmeister/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


. "$HOME/.local/share/../bin/env"

# opencode
export PATH=/home/tmeister/.opencode/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

# Source git aliases
[ -f ~/.config/zsh/git-aliases.zsh ] && source ~/.config/zsh/git-aliases.zsh
