function get_sail_artisan_completions
    begin
        ./vendor/bin/sail artisan list --raw 2>/dev/null
        or return
    end | grep -vE '^ ' | string replace -r '\s+' '\t'
end

function sail 
    if test -f './vendor/bin/sail'  
        ./vendor/bin/sail $argv
    else
        echo "Sail not found"
    end
end

#alias sail="./vendor/bin/sail"
alias saildebug="./vendor/bin/sail php -d xdebug.mode=debug -d xdebug.client_host=host.docker.internal -d xdebug.client_port=9003 -d xdebug.start_with_request=yes"

complete -c sail -f -n 'test -f ./vendor/bin/sail; and __fish_seen_subcommand_from artisan' -a '(get_sail_artisan_completions)'
