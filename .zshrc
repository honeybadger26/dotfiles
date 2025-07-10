################################### PLUGINS ###################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load zsh plugins (Mac)
# source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load zsh plugins (Linux)
source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

################################### OPTIONS ###################################

# Remove right padding in prompt
ZLE_RPROMPT_INDENT=0

# Share command history between all zsh sessions
setopt SHARE_HISTORY

# Set history file location and size limits
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Automatically insert the first completion match
setopt MENU_COMPLETE

# Initialize completion system and Load completion list module
autoload -Uz compinit && compinit
zmodload -i zsh/complist

# Enable completion meu
zstyle ':completion:*' menu select

# Enable case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

################################# KEY BINDINGS #################################

# Press Enter only once to accept current suggestion
bindkey -M menuselect '^M' .accept-line

# Use Shift+Tab to move through completion backwards
bindkey '^[[Z' reverse-menu-complete

# Fuzzy find history backwards by typing + Up arrow. Credit to ohmyzsh
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search

# Fuzzy find history forwards by typing + Down arrow. Credit to ohmyzsh
autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

############################## ALIASES/FUNCTIONS ##############################

# Credit to ohmyzsh
function _git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done
  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

function grw() {
  local main_branch=$(_git_main_branch)
  git checkout $main_branch
  git pull
  git checkout -
  git rebase $main_branch
}

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias gaf='git add . && git commit --fixup'
alias gb='git branch'
alias gcb='git checkout -b'
alias gco='git checkout'
alias gf='git commit --fixup'
alias grc='git rebase --continue'
alias gri='git rebase --interactive --autosquash $(_git_main_branch)'
alias gst='git status'
alias l='ls -lAh --color=auto'
