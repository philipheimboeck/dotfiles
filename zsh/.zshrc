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

# Yubikey SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
gpgconf --launch gpg-agent

# Plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source ~/.dotfiles/zsh/antigen/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen apply


if [ -x "$(which thefuck)" ] ; then
    eval $(thefuck --alias)
else    
    echo "thefuck not found"
fi
