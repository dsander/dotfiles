# zmodload zsh/zprof

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

OS=$(uname)

# case-insensitive (all), partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# enable completion menu
zstyle ':completion:*' menu select

# makes color constants available
autoload -U colors
colors

# PATH manipulation
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
export MANPATH="${HOMEBREW_PREFIX}/share/man:$MANPATH"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:$INFOPATH"
export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:$PATH"
export PATH=$HOME/.cargo/bin:$HOME/bin:$PATH
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# History
if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.zsh_history
fi

SAVEHIST=100000000
HISTSIZE=$SAVEHIST

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

source ~/.zplugin/bin/zplugin.zsh

# Prompt setup
setopt promptsubst

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context                 # user@hostname
    dir                     # current directory
    vcs                     # git status
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
)

typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=false
typeset -g POWERLEVEL9K_VCS_GIT_ICON=''
typeset -g POWERLEVEL9K_HOME_ICON=''
typeset -g POWERLEVEL9K_HOME_SUB_ICON=''
typeset -g POWERLEVEL9K_ETC_ICON=''

zplugin ice depth=1
zplugin load romkatv/powerlevel10k

# zplugin ice lucid
# zplugin snippet OMZ::lib/git.zsh

zplugin ice wait atload"unalias grv" lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin ice svn wait lucid 
zplugin snippet OMZ::plugins/mix-fast

zplugin ice svn wait lucid 
zplugin snippet OMZ::plugins/bundler

zplugin ice wait as"completion" lucid
zplugin snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zplugin ice wait as"completion" lucid
zplugin snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/cargo/_cargo

zplugin ice wait as"completion" lucid
zplugin snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/gem/_gem

zplugin ice wait as"completion" lucid
zplugin snippet https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/terraform/_terraform

zplugin ice wait as"completion" lucid
zplugin snippet https://github.com/junegunn/fzf/blob/master/shell/completion.zsh

zplugin ice wait lucid
zplugin snippet https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh

zplugin ice light lucid
zplugin load kiurchv/asdf.plugin.zsh

zplugin ice wait lucid blockf
zplugin load zsh-users/zsh-completions

zplugin ice wait atinit"zpcompinit; zpcdreplay" lucid
zplugin load zdharma/fast-syntax-highlighting

# zplugin ice wait atload"_zsh_autosuggest_start" lucid
# zplugin load zsh-users/zsh-autosuggestions

zplugin ice wait atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" lucid
zplugin load zsh-users/zsh-history-substring-search

zplugin ice wait"2" lucid as"program" pick"bin/git-dsf"
zplugin load zdharma/zsh-diff-so-fancy

zplugin ice as"program" pick"yank" make
zplugin load mptre/yank

zplugin ice wait lucid
zplugin snippet "${HOMEBREW_PREFIX}/etc/profile.d/autojump.sh"

zplugin ice from"gh-r" as"program" lucid
zplugin load junegunn/fzf-bin

zplugin ice pick"fzf-tmux" as"program" lucid
zplugin snippet https://github.com/junegunn/fzf/blob/master/bin/fzf-tmux 

# Integrations & completions
if [[ "${OS}" == "Darwin" ]]; then
  # enable colored output from ls, etc. on FreeBSD-based systems
  export CLICOLOR=1

  zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”

  zplugin ice wait pick'init.zsh' compile'*.zsh' lucid
  zplugin load laggardkernel/zsh-iterm2
else
  zplugin ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
      atpull'%atclone' pick"clrs.zsh" nocompile'!' \
      atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
  zplugin load trapd00r/LS_COLORS
fi

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
bindkey "\e[3~" delete-char

# Use vim keys in tab complete menu:
zmodload -i zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

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

# Git commits
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
alias nhscp="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
alias vim='nvim'

# zprof
