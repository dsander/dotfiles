# zmodload zsh/zprof

lazy_source () {
  eval "$1 () { [ -f $2 ] && source $2 && $1 \$@ }"
}

OS=$(uname)

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
# HIST_STAMPS="yyyy-mm-dd"
SAVEHIST=100000000
HISTSIZE=$SAVEHIST

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bundler rails ruby coffee docker gem git-flow tmuxinator history-substring-search vagrant mix-fast cargo terraform)

source $ZSH/oh-my-zsh.sh

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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


# User configuration
export EDITOR=vim
export TERM=screen-256color
export DEFAULT_USER=dominik
export BUNDLER_EDITOR=vim


# PATH manipulation
export PATH=$HOME/.cargo/bin:$HOME/bin:$PATH
if [[ "${OS}" == "Darwin" ]]; then
  export HOMEBREW_PREFIX="/usr/local"

  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  export PATH="/usr/local/heroku/bin:$PATH"

  test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
else
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
fi

export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
export PATH="${HOMEBREW_PREFIX}/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
export MANPATH="${HOMEBREW_PREFIX}/share/man:$MANPATH"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:$INFOPATH"


# Integrations & completions
if [[ "${OS}" == "Darwin" ]]; then
  test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
else
fi

lazy_source j "${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh"
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh


# Aliases
alias diffscreens='cd ~/Dropbox/Screenshots && compare -density 300 "`ls -tr | tail -2|head -1`" "`ls -tr | tail -1`" -compose src diff.png; open diff.png'
alias dm='/usr/local/bin/docker-machine'
alias mux='tmuxinator'
alias subl='reattach-to-user-namespace subl'
alias macvim='reattach-to-user-namespace macvim'
alias open='reattach-to-user-namespace open'
alias zcat='gunzip -c'
alias nhssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# zprof
