if status is-interactive
    # Commands to run in interactive sessions can go here
end
zoxide init fish | source
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias lt='eza --tree --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first --all'
alias nvim='command nvim'
alias vim='command nvim'
alias vi='command nvim'
#utility aliases
alias sc='source ~/.config/fish/config.fish'
# Wifi QR
alias wifiqr='nmcli device wifi show-password'

# Power 
alias reboot="reboot --no-wall"
alias poweroff="poweroff --no-wall"

# git
alias lg='lazygit'

# System
alias grep='rg'

alias du='dust'
alias df='df -h'
alias free='free -h'
alias ps='ps auxf'
alias mount='mount | column -t'
# pnpm
set -gx PNPM_HOME '/home/sandip/.local/share/pnpm'
if test "$PATH[1]" != "$PNPM_HOME/bin"
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end
# opencode
fish_add_path /home/sandip/.opencode/bin

fish_add_path /home/sandip/.spicetify

starship init fish | source

if status is-interactive
    atuin init fish | source
end
