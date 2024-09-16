if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export XDEBUG_SESSION=1
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=~/.composer/vendor/bin:$PATH
export ZSH="/Users/tmeister/.oh-my-zsh"
export SSH_KEY_PATH="~/.ssh/id_rsa"
export BAT_THEME="tokyonight"

ZSH_THEME="robbyrussell"

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
MODE_INDICATOR="%F{white}+%f"
INSERT_MODE_INDICATOR="%F{yellow}+%f"
bindkey -M viins 'jj' vi-cmd-mode


plugins=(git vi-mode)
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

INSERT_MODE_INDICATOR="%F{yellow}+%f"

alias zshreset="source ~/.zshrc"
alias c="clear"
alias e="exit"
alias weather='curl -s "wttr.in/Valle%20de%20Bravo" | sed -n "1,7p"'
alias a="php artisan"
alias nah!="git reset --hard HEAD"
alias tinker="artisan tinker"
alias gl="npm list -g --depth 0"
alias dns="sudo /etc/init.d/networking restart"
alias pest="./vendor/bin/pest"
alias dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias lup='brew services start mariadb && brew services start redis && valet start'
alias ldo='brew services stop mariadb && brew services stop redis && valet stop'
alias s='sail'
alias sa='sail artisan'
alias nu='nvm use'
alias sup='sail up -d'
alias sdo='sail down'
alias php7="brew link php@7.4 --force --overwrite"
alias php8="brew link php@8.1 --force --overwrite"
alias vim="nvim"
alias t="tmux"
alias pw="~/.dotfiles/scripts/tmux-sessionizer"
alias vstart="valet start && brew services start mariadb"
alias vstop="valet stop && brew services stop mariadb"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
