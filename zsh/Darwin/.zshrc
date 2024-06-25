export PATH="$HOME/.composer/vendor/bin/:$PATH"

# Yubikey SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
gpgconf --launch gpg-agent

alias sail="./vendor/bin/sail"
