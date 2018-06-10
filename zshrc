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
plugins=(git bundler cap rails ruby coffee docker gem git-flow tmuxinator history-substring-search vagrant mix-fast cargo)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH=$HOME/.cargo/bin:$HOME/bin:$PATH
export EDITOR=vim
export TERM=screen-256color
export DEFAULT_USER=dominik
export BUNDLER_EDITOR=vim

# VS Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# Add homebrew
export PATH=/usr/local/sbin:$PATH

# lazy load rbenv
rbenv() {
  eval "$(command rbenv init -)"
  rbenv "$@"
}
export PATH="$HOME/.rbenv/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# nvm
export NVM_DIR=~/.nvm
lazy_source nvm "/usr/local/opt/nvm/nvm.sh"

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# kiex elixir version manager
lazy_source kiex "$HOME/.kiex/scripts/kiex"

# added by travis gem
[ -f /Users/dominik/.travis/travis.sh ] && source /Users/dominik/.travis/travis.sh

# autojump
lazy_source j "/usr/local/etc/profile.d/autojump.sh"

# handy keybindings
bindkey "^s" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-char
bindkey "^b" backward-char
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line

# Open current command in Vim
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^x^e" edit-command-line

# Copy the most recent command to the clipboard
function _pbcopy_last_command(){
	history | tail -1 | sed 's/ *[0-9]* *//' | pbcopy
}
zle -N pbcopy-last-command _pbcopy_last_command
bindkey '^x^y' pbcopy-last-command

# Fuzzy match against history, edit selected value
_uniqe_without_sort() { awk '!x[$0]++' }
_fuzzy_history() {
  zle -U "$(
  history | \
    tail -2000 | \
    sed 's/ *[0-9]* *//' | \
    _uniqe_without_sort | \
    fzf-tmux --tac --reverse --no-sort
  )"
}
zle -N fuzzy-history _fuzzy_history
bindkey '^r' fuzzy-history

# Git branches
_fuzzy_git_branches() {
  zle -U "$(
  git branch --color=always | \
    fzf-tmux --reverse --ansi --tac | \
    sed -E 's/^[ \t]*//'
  )"
}
zle -N fuzzy-git-branches _fuzzy_git_branches
bindkey '^g^b' fuzzy-git-branches

# Git files
_fuzzy_git_status_files() {
  zle -U "$(
  git -c color.status=always status --short | \
    fzf-tmux --ansi --reverse --no-sort | \
    cut -d ' ' -f 3
  )"
}
zle -N fuzzy-git-status-files _fuzzy_git_status_files
bindkey '^g^f' fuzzy-git-status-files

# Git files
_fuzzy_git_shalector() {
  commit=$(
  git log --color=always --oneline --decorate --all -35 | \
    fzf-tmux --ansi --reverse --no-sort
  )
  zle -U "$(echo $commit | cut -d ' ' -f 1)"
  zle -M "$commit"
}
zle -N fuzzy-git-shalector _fuzzy_git_shalector
bindkey '^g^g' fuzzy-git-shalector


# Aliases

alias diffscreens='cd ~/Dropbox/Screenshots && compare -density 300 "`ls -tr | tail -2|head -1`" "`ls -tr | tail -1`" -compose src diff.png; open diff.png'
alias dm='/usr/local/bin/docker-machine'
alias mux='eval "$(command rbenv init -)"; tmuxinator'
alias subl='reattach-to-user-namespace subl'
alias macvim='reattach-to-user-namespace macvim'
alias open='reattach-to-user-namespace open'
alias zcat='gunzip -c'
alias nhssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

