lazy_source () {
  eval "$1 () { [ -f $2 ] && source $2 && $1 \$@ }"
}

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler cap rails ruby coffee docker gem git-flow tmuxinator history-substring-search vagrant mix-fast)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/bin:$PATH
export EDITOR=vim
export TERM=screen-256color
export DEFAULT_USER=dominik
export BUNDLER_EDITOR=vim

export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Add homebrew
export PATH=/usr/local/sbin:$PATH

# rbenv
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# nvm
export NVM_DIR=~/.nvm
lazy_source nvm "/usr/local/opt/nvm/nvm.sh"

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# kiex elixir version manager
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# added by travis gem
[ -f /Users/dominik/.travis/travis.sh ] && source /Users/dominik/.travis/travis.sh

# autojump
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh


# Aliases

alias diffscreens='cd ~/Dropbox/Screenshots && compare -density 300 "`ls -tr | tail -2|head -1`" "`ls -tr | tail -1`" -compose src diff.png; open diff.png'
alias dm='/usr/local/bin/docker-machine'
alias mux=tmuxinator
alias subl='reattach-to-user-namespace subl'
alias macvim='reattach-to-user-namespace macvim'
alias open='reattach-to-user-namespace open'
alias dokku='bash $HOME/code/infrastructure/dokku/contrib/dokku_client.sh'
alias zcat='gunzip -c'

