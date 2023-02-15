export PATH="$PATH:$HOME/.local/bin"
export ANDROID_HOME=$HOME/Android/Sdk

export PATH=$(go env GOPATH)/bin:$PATH

alias host-staging="aws ec2 describe-instances --filters \"Name=instance.group-name,Values=staging-ecs-security-group-ec2\" | jq '.Reservations[0].Instances[0].PublicDnsName' | tr -d '\"'"

alias ssh-staging="ssh `host-staging`"
