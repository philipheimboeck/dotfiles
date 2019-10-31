export PATH="/usr/local/opt/php@7.2/bin:$PATH"
export PATH="/usr/local/opt/php@7.2/sbin:$PATH"

function vssh () {
  cd ~/Projects/start/Vagrant && vagrant ssh
}
function vdown () {
  cd ~/Projects/start/Vagrant && vagrant suspend
}
function vup () {
  cd ~/Projects/start/Vagrant && vagrant up && vagrant ssh
}
