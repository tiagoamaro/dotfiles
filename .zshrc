ZSH=$HOME/.oh-my-zsh # Path to your oh-my-zsh configuration
ZSH_THEME="avit"
COMPLETION_WAITING_DOTS="true"
plugins=(git rails brew rvm vagrant bower npm powder brew-cask docker)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Node
PATH=$PATH:/usr/local/Cellar/node/HEAD/bin # Add NPM binaries

alias l='ls'
alias ll='ls -lash'
alias rake='noglob rake'
alias be='bundle exec'
alias z='zeus'
alias zs='zeus start'
alias zc='zeus console'
alias fs='foreman start'
alias gall='gitk --all'
alias gitlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%aN>%Creset'"
alias srails="spring rails"
alias srake="spring rake"
alias srspec="spring rspec"
alias cask="brew cask"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Postgres.app
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin"

# RVM
# export PATH="$PATH:$HOME/.rvm/bin"
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# chruby
source /usr/local/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh # Enable Auto Switching rubies based on .ruby-version files
