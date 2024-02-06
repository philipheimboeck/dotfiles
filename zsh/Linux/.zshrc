export PATH="$PATH:$HOME/.local/bin"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH=$PATH:/usr/local/go/bin

alias host-staging="aws ec2 describe-instances --filters \"Name=instance.group-name,Values=staging-ecs-security-group-ec2\" | jq '.Reservations[0].Instances[0].PublicDnsName' | tr -d '\"'"
alias host-production="aws ec2 describe-instances --filters \"Name=instance.group-name,Values=production-ecs-security-group-ec2\" | jq '.Reservations[0].Instances[0].PublicDnsName' | tr -d '\"'"

alias ssh-staging="ssh `host-staging`"
alias ssh-production="ssh `host-production`"

alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lah"

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

