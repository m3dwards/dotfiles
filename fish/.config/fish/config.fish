
fish_add_path $HOME/bin:/usr/local/bin
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/go/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/ruby/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias k kubectl
direnv hook fish | source
