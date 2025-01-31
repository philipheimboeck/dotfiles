export PATH="$HOME/.composer/vendor/bin/:$PATH"

alias sail="./vendor/bin/sail"
alias saildebug="./vendor/bin/sail php -d xdebug.mode=debug -d xdebug.client_host=host.docker.internal -d xdebug.client_port=9003 -d xdebug.start_with_request=yes"

prepend_path_if_not_exists /opt/homebrew/bin
prepend_path_if_not_exists /opt/homebrew/sbin
