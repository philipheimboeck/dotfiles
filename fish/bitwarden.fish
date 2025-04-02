function unlock_bw_if_locked
    if test -z "$BW_SESSION"
        echo 'bw locked - unlocking into a new session'
        set -gx BW_SESSION (bw unlock --raw)
    end
end

