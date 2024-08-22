

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
alias weather='curl wttr.in/melbourne'
alias fman='compgen -c | fzf | xargs man'
alias fzf='fzf --preview="bat --color=always {}"'
alias speed='speedtest-cli'

# Start tmux automatically
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

# shell fn to create zettel note from terminal
zk() {
    read -p "title: " filename
    nvim ~/1-projects/vaults/sub0x_vault/0-zettel/"$filename".md
}

# Function to add a log entry to today's note
zkl() {
    # Define the path to your notes
    notes_path=~/1-projects/vaults/sub0x_vault/5-notes
    # Get today's date in YYYY-MM-DD format
    today=$(date +%Y-%m-%d)
    # Define the full path to today's note
    todays_note="$notes_path/$today.md"
    # Create today's note with template if it doesn't exist
    if [ ! -f "$todays_note" ]; then
        create_daily_note
    fi
    # Prompt for the log entry
    read -p "Log entry: " log_entry
    # Add the log entry under the Log section
    sed -i '/# Log/,/^---/{/^---/!s/$/\n- '"$log_entry"'/;:a;n;ba}' "$todays_note"
    echo "Entry added to $todays_note"
}

# Function to add a todo item to today's note
zkt() {
    # Define the path to your notes
    notes_path=~/1-projects/vaults/sub0x_vault/5-notes
    # Get today's date in YYYY-MM-DD format
    today=$(date +%Y-%m-%d)
    # Define the full path to today's note
    todays_note="$notes_path/$today.md"
    # Create today's note with template if it doesn't exist
    if [ ! -f "$todays_note" ]; then
        create_daily_note
    fi
    # Prompt for the todo item
    read -p "Todo item: " todo_item
    # Add the todo item under the Todo section
    sed -i '/# Todo/,/^---/{/^---/!s/$/\n- [ ] '"$todo_item"'/;:a;n;ba}' "$todays_note"
    echo "Todo item added to $todays_note"
}

# Function to create a new daily note with the template
create_daily_note() {
    cat << EOF > "$todays_note"
---
id: $(uuidgen)
title: $today
desc: journal and log with tasks
alias: []
tags: [daily, journal]
---
---
>  [[$(date -d "yesterday" +%Y-%m-%d)]] <=> [[$(date -d "tomorrow" +%Y-%m-%d)]]
---
# Log
-
---
# Todo

- [ ] 
---
> [[5-notes]]
EOF
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
