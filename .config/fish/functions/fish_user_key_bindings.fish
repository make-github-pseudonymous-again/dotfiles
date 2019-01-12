
function fish_user_key_bindings

    # vi-like key bindings
    fish_vi_key_bindings

    ### sudope insert mode ###
    set -q sudope_sequence
    or set -l sudope_sequence \cn
    test (bind | grep -q 'bind -M insert .* sudope')
    or set -l do_bind
    if test (bind -M insert $sudope_sequence ^/dev/null)
        echo "sudope: The requested sequence is already in use:" (bind $sudope_sequence | cut -d' ' -f2-)
    else if set -q do_bind
        bind -M insert $sudope_sequence sudope
    end

    # Auto-complete shortcuts
    bind -M insert \co forward-char
    bind -M insert \cp accept-autosuggestion

    # fzf key bindings
    fzf_key_bindings

end
