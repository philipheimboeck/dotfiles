# Load VCS information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format zhe vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{green}[%b]%f'

# Set up the prompot
setopt PROMPT_SUBST
PROMPT='${PWD/#$HOME/~} ${vcs_info_msg_0_} > '

# Yubikey SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
gpgconf --launch gpg-agent

# Plugins

source ~/.dotfiles/zsh/antigen/antigen.zsh
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


eval $(thefuck --alias)
