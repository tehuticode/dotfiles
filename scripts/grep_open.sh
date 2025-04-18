
#!/usr/bin/env bash

gif() {
  local DEBUG=0

  print_help() {
    cat << EOF
Usage: gif [OPTIONS]

Search for files and open them in Neovim within tmux panes.

Options:
  --debug     Enable debug output
  --help      Display this help message

Controls:
  Ctrl+f      Search filenames
  Ctrl+g      Search file contents
  Ctrl+d      Search directories

Environment Variables:
  NVIM_SEARCH_REGISTRY    Set to the search query, allowing Neovim to highlight matches

Example:
  gif             # Run the normal search and open
  gif --debug     # Run with debug output
EOF
  }

  debug() {
    [[ $DEBUG -eq 1 ]] && echo "DEBUG: $@" >&2
  }

  get_fzf_output() {
    local RG_BIND="ctrl-g:reload:rg --line-number --no-heading --color=always --smart-case --glob '!**/.git/**' --glob '!node_modules/**' '' 2>/dev/null || true"
    local FILE_BIND="ctrl-f:reload:rg --files --glob '!**/.git/**' --glob '!node_modules/**' 2>/dev/null || true"
    if command -v fd &>/dev/null; then
      DIR_BIND="ctrl-d:change-prompt(directory> )+reload(cd $HOME && echo $HOME; fd --type d --hidden --absolute-path --color never --exclude .git --exclude node_modules)"
    else
      DIR_BIND="ctrl-d:change-prompt(directory> )+reload(cd $HOME && find ~+ -type d -name node_modules -prune -o -name .git -prune -o -type d -print)"
    fi

    rg --line-number --no-heading --color=always --smart-case --glob '!**/.git/**' --glob '!node_modules/**' '' 2>/dev/null | \
      fzf --ansi --multi --delimiter : \
          --print-query \
          --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || echo "Preview not available"' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
          --bind "$FILE_BIND" \
          --bind "$RG_BIND" \
          --bind "$DIR_BIND" \
          --bind 'ctrl-c:abort' \
          --header "Press Ctrl+f to search filenames, Ctrl+g to search file contents, Ctrl+d to search directories"
  }

  set_nvim_search_variable() {
    local raw_output="$1"
    local query=$(echo "$raw_output" | head -n1)
    export NVIM_SEARCH_REGISTRY="$query"
  }

  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --debug)
        DEBUG=1
        shift
        ;;
      --help)
        print_help
        return 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        print_help
        return 1
        ;;
    esac
  done

  for cmd in rg fzf bat tmux nvim; do
    if ! command -v $cmd &> /dev/null; then
      echo "Error: $cmd not found" >&2
      return 1
    fi
  done
  if [ -z "$TMUX" ]; then
    echo "Error: Not in a tmux session" >&2
    return 1
  fi

  local raw_output
  raw_output=$(get_fzf_output)
  debug "Raw fzf output:"
  debug "$raw_output"
  set_nvim_search_variable "$raw_output"

  # Split the newline-delimited output into an array, skipping the first line (query)
  local selections
  mapfile -t selections < <(echo "$raw_output" | sed 1d)

  debug "Number of selections: ${#selections[@]}"
  debug "Selections:"
  debug "$(printf '%s\n' "${selections[@]}")"
  if (( ${#selections[@]} == 0 )); then
    debug "No selections made"
    return 0
  fi
  local files=()
  local lines=()
  local count=0
  for selection in "${selections[@]}"; do
    local file=$(echo "$selection" | awk -F: '{print $1}')
    local line=$(echo "$selection" | awk -F: '{print $2}')
    debug "Processing selection: $selection"
    debug "File: $file, Line: $line"
    if [[ -f "$file" ]]; then
      files+=("$file")
      lines+=("$line")
      ((count++))
    else
     debug "File not found: $file"
    fi
  done
  debug "Number of valid files: $count"
  debug "Valid files:"
  debug "$(printf '%s\n' "${files[@]}")"
  if (( $count == 0 )); then
    debug "No valid files selected"
    return 0
  fi
  open_files_in_nvim() {
    local pane=$1
    shift
    local file_indices=("$@")
    local nvim_cmd="nvim"
    for index in "${file_indices[@]}"; do
      nvim_cmd+=" +${lines[$index]} ${files[$index]}"
    done
    nvim_cmd+=" -c 'let @/=\"$NVIM_SEARCH_REGISTRY\"'"
    debug "Running command in pane $pane: $nvim_cmd"
    tmux send-keys -t "$pane" "$nvim_cmd" C-m
  }
  if (( $count == 1 )); then
    debug "Opening single file"
    open_files_in_nvim "$(tmux display-message -p '#P')" 1
  else
    debug "Opening multiple files"
    local window_name="gif-$(date +%s)"
    tmux new-window -n "$window_name"
    case $count in
      2)
        debug "Opening 2 files side-by-side"
        tmux split-window -t "$window_name" -h -p 50
        open_files_in_nvim "$window_name.1" 1
        open_files_in_nvim "$window_name.2" 2
        tmux select-pane -t "$window_name.1"
        ;;
      3)
        debug "Opening 3 files"
        tmux split-window -t "$window_name" -h -p 50
        tmux split-window -t "$window_name.2" -v -p 50
        open_files_in_nvim "$window_name.1" 1
        open_files_in_nvim "$window_name.2" 2
        open_files_in_nvim "$window_name.3" 3
        ;;
      *)
        debug "Opening 4 or more files"
        tmux split-window -t "$window_name" -h -p 50
        tmux split-window -t "$window_name.1" -v -p 50
        tmux split-window -t "$window_name.3" -v -p 50
        open_files_in_nvim "$window_name.1" 1
        open_files_in_nvim "$window_name.2" 2
        open_files_in_nvim "$window_name.3" 3
        local remaining_indices=("${!files[@]:3}")
        open_files_in_nvim "$window_name.4" "${remaining_indices[@]}"
        ;;
    esac
  fi
  debug "Function completed"
}

