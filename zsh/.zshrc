zmodload zsh/zprof

# ZSH Config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

# Load VCS information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format zhe vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{green}[%b]%f'

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

source ~/.dotfiles/zsh/antigen/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle lukechilds/zsh-nvm
antigen bundle laggardkernel/zsh-thefuck
antigen apply


if [ -x "$(which thefuck)" ] ; then
    #eval $(thefuck --alias) # Loaded via plugin now
else    
    echo "thefuck not found. Please install first: https://github.com/nvbn/thefuck#installation"
fi


