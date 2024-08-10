

# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Custom prompt
PS1='[\u@\h \W]\$ '

# Enable color support of ls and add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='exa -lah --color=auto --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Additional aliases
alias ll='exa -alF'
alias la='exa -A'
alias l='exa -CF'
alias vim='nvim'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias fetch='neofetch'
alias shutdown='sync; shutdown -h now'
# alias fd=fdfinear
alias tor='cd ~/Documents/tor-browser && ./start-tor-browser.desktop'
alias commit='git add -A; git commit -m'
alias ssha='eval $(ssh-agent) && ssh-add'
alias virt='virt-manager'
alias tm="tmux"
alias powerm="xfce4-power-manager-settings"
alias update='sudo pacman -Syu'
alias reload='source ~/.bashrc'


# shell fn to create zettel note from terminal
note() {
    read -p "title: " filename
    nvim ~/1-projects/vaults/sub0x_vault/0-zettel/"$filename".md
}


# Starship prompt
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# FZF default command
export FZF_DEFAULT_COMMAND='fd --type f'
export TERM=xterm-256color
export PATH="$HOME/.atuin/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH

# Source preexec if available
[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# Set default browser
export BROWSER=nautilus

. "$HOME/.cargo/env"
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

# Created by `pipx` on 2024-07-22 04:12:44
export PATH="$PATH:/home/sub0x/.local/bin"

export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools



PATH="/home/sub0x/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/sub0x/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sub0x/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sub0x/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sub0x/perl5"; export PERL_MM_OPT;
eval "$(luarocks path --bin)"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools
