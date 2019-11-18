# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source ~/.p10k.zsh

# zmodload zsh/zprof

lazy_source () {
  eval "$1 () { [ -f $2 ] && source $2 && $1 \$@ }"
}

OS=$(uname)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh


## case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc. on FreeBSD-based systems
export CLICOLOR=1

# PATH manipulation
export PATH=$HOME/.cargo/bin:$HOME/bin:$PATH
if [[ "${OS}" == "Darwin" ]]; then
  export HOMEBREW_PREFIX="/usr/local"

  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
  export PATH="/usr/local/heroku/bin:$PATH"
else
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
fi

export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
export PATH="${HOMEBREW_PREFIX}/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
export MANPATH="${HOMEBREW_PREFIX}/share/man:$MANPATH"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:$INFOPATH"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
UNBUNDLED_COMMANDS=(annotate cap capify cucumber foodcritic guard hanami irb jekyll kitchen knife middleman nanoc pry puma rackup rainbows rake rspec rubocop shotgun sidekiq spec spork spring strainer tailor taps thin thor unicorn unicorn_rails ify _rails)

plugins=(git bundler rails ruby coffee docker gem git-flow tmuxinator history-substring-search vagrant mix-fast cargo terraform)

# source $ZSH/oh-my-zsh.sh
source ~/.zplugin/bin/zplugin.zsh

if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

SAVEHIST=100000000
HISTSIZE=$SAVEHIST

# Show history
case $HIST_STAMPS in
  "mm/dd/yyyy") alias history='fc -fl 1' ;;
  "dd.mm.yyyy") alias history='fc -El 1' ;;
  "yyyy-mm-dd") alias history='fc -il 1' ;;
  *) alias history='fc -l 1' ;;
esac

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

setopt promptsubst

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
zplugin ice depth=1
zplugin load romkatv/powerlevel10k


# zplugin ice lucid
# zplugin snippet OMZ::lib/git.zsh

zplugin ice wait atload"unalias grv" lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin ice wait lucid
zplugin load kiurchv/asdf.plugin.zsh

zplugin ice wait lucid blockf
zplugin load zsh-users/zsh-completions

zplugin ice wait atinit"zpcompinit; zpcdreplay" lucid
zplugin load  zdharma/fast-syntax-highlighting

zplugin ice wait atload"_zsh_autosuggest_start" lucid
zplugin load  zsh-users/zsh-autosuggestions

# PS1="READY >" # provide a nice prompt till the theme loads
# zplugin ice '!' lucid
# zplugin snippet OMZ::themes/agnoster.zsh-theme

zplugin ice wait atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" lucid
zplugin load zsh-users/zsh-history-substring-search


# Integrations & completions
if [[ "${OS}" == "Darwin" ]]; then
  # test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
else
fi

lazy_source j "${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh"
# [ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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


# User configuration
export EDITOR=vim
export TERM=screen-256color
export DEFAULT_USER=dominik
export BUNDLER_EDITOR=vim






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
