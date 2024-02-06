zmodload zsh/zprof

# ZSH Config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt    histignoredups    #Ignore duplicates in the history file


# Load VCS information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format zhe vcs_info_msg_0_ variable
#zstyle ':vcs_info:git:*' formats '%F{green}[%b]%f'
zstyle :prompt:pure:git:stash show yes

# Set up the prompot
setopt PROMPT_SUBST
PROMPT='${PWD/#$HOME/~} ${vcs_info_msg_0_} > '

# Keys
bindkey "^[[3~" delete-char

# Machine - Imports
OS_FILE="$HOME/.dotfiles/zsh/$(uname -s)/.zshrc"
if [ -f "$OS_FILE" ]; then
  source $OS_FILE
fi
source "$HOME/.dotfiles/zsh/git-aliases"


# Plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=2"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=1
export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.nvm"

source "$HOME/.dotfiles/zsh/antidote/antidote.zsh"
antidote load "$HOME/.dotfiles/zsh/.zsh_plugins.txt"


if [ -x "$(which thefuck)" ] ; then
    #eval $(thefuck --alias) # Loaded via plugin now
else    
    echo "thefuck not found. Please install first: https://github.com/nvbn/thefuck#installation"
fi

# Load nvm file when opening a directory with .nvmrc file
autoload -U add-zsh-hook

nvm_echo() {
  command printf %s\\n "$*" 2>/dev/null
}

nvm_find_up() {
  local path_
  path_="${PWD}"
  while [ "${path_}" != "" ] && [ ! -f "${path_}/${1-}" ]; do
    path_=${path_%/*}
  done
  nvm_echo "${path_}"
}

nvm_find_nvmrc() {
  local dir
  dir="$(nvm_find_up '.nvmrc')"
  if [ -e "${dir}/.nvmrc" ]; then
    nvm_echo "${dir}/.nvmrc"
  fi
}

load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -f "$nvmrc_path" ]; then 
    local node_version="$(nvm version)"
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


RPROMPT="[%D{%f/%m/%y} | %D{%L:%M:%S}]"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
