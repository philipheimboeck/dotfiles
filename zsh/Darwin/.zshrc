export PATH="$HOME/.composer/vendor/bin/:$PATH"
export PATH="/usr/local/sbin:$PATH"


# Yubikey SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
gpgconf --launch gpg-agent


function vssh () {
  cd ~/Projects/start/homestead && vagrant ssh
}
function vdown () {
  cd ~/Projects/start/homestead && vagrant suspend
}
function vup () {
  cd ~/Projects/start/homestead && vagrant up && vagrant ssh
}
function dup () {
  cd ~/Projects/start/docker && docker-compose up -d 
}
function ddown () {
  cd ~/Projects/start/docker && docker-compose stop
}
function dssh () {
  cd ~/Projects/start/docker && docker-compose exec php /bin/bash
}

# Alias PHP versions
phpAliasesFile="$HOME/.dotfiles/zsh/Darwin/phpAliases"
function updatePHPVersions () {

  installedPhpVersions=($(brew ls --versions | ggrep -E 'php(@.*)?\s' | ggrep -oP '(?<=\s)\d\.\d' | uniq | sort))
  echo "" > $phpAliasesFile

  for phpVersion in ${installedPhpVersions[*]}; do
    value="{"

    for otherPhpVersion in ${installedPhpVersions[*]}; do
        if [ "${otherPhpVersion}" != "${phpVersion}" ]; then
            value="${value} brew unlink php@${otherPhpVersion};"
        fi
    done

    value="${value} brew link php@${phpVersion} --force --overwrite; } &> /dev/null && php -v"
    
    echo "alias \"php${phpVersion}\"=\"${value}\"" >> $phpAliasesFile
  done
  
  echo "PHP Versions"
  cat "$phpAliasesFile"
  source "$phpAliasesFile"
}
source "$phpAliasesFile"
