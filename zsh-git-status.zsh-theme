#!/bin/zsh

# Headline ZSH Prompt
# Copyright (c) 2025 Chris W Hendricks under the MIT License

# This is my first attempt at creating a ZSH prompt theme.
# It is a work in progress and I am open to suggestions and improvements.
# The goal is to create a clean and modern prompt that is easy to read and use.
# Use At Your Own Risk! ☠️

# To install, source this file from your ~/.zshrc


# Git status indicators with modern symbols
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#00ff00}\uf058%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{#26a641}%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{#f85149}󰮈%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{#2188ff}󰑕%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{#bf5af2}%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{202}\uf06d"
ZSH_THEME_GIT_PROMPT_STASHED="%F{#87ceeb}%f"
ZSH_THEME_GIT_PROMPT_BEHIND="%F{#ff5555}%f"
ZSH_THEME_GIT_PROMPT_AHEAD="%F{#50fa7b}%f"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%F{red}\uf06a%f"

git_prompt_status_cwh(){
    local INDEX=$(command git status --porcelain -b 2> /dev/null)
    local STATUS=""
  
    # ADDED
    if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
        if $(echo "$INDEX" | grep '^A ' &> /dev/null); then
            STATUS="$ZSH_THEME_GIT_PROMPT_ADDED $STATUS "
        fi
    fi

    # MODIFIED
    if $(echo "$INDEX" | grep '^M\s' &> /dev/null) || $(echo "$INDEX" | grep '^\sM' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi

    # DELETED
    if $(echo "$INDEX" | grep '^D ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi

    # RENAMED
    if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
    fi

    # UNMERGED
    if $(echo "$INDEX" | grep '^U ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi

    # STAGED
    if $(echo "$INDEX" | grep '^[MADRC]M ' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_STAGED$STATUS"
    fi

    if $(echo "$INDEX" | grep -E 'behind' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
    fi

    if $(echo "$INDEX" | grep -E 'ahead' &> /dev/null); then
        STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
    fi

    # If no status is found, set to clean
    if [ -z "$STATUS" ]; then
        STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi

    untracked_count=$(git status --porcelain | awk '/^\?\?/ {count++} END {print count}')

    # check if untracked_count is empty
    if [ -z "$untracked_count" ]; then
        untracked_count=0
    fi
    if [ $untracked_count -gt 0 ]; then
        STATUS="$STATUS  $ZSH_THEME_GIT_PROMPT_UNTRACKED $untracked_count"
    fi
  
   
    echo "$STATUS "
}

declare -A COLORS
COLORS=(
    [PATH_BG]="#FFD43B"
    [PROMPT_FG]="%B%F{#00ffff}%b"
    [NEON_GREEN]="#00ff00"
    [NEON_MAGENTA]="#ff00ff"
    [WHITE]="#52575C"
   
)

ZSH_CWH_LINEFEED=$'\n'

declare -A ICONS
ICONS=(
    [TIMER]="⏱"
    [HOME]=$'\uf015'
    [PROMPT_CHAR]=$'\uf120'
    [LINEFEED]=$'\n'
    [GIT_ICON]=$'\ue65d'
    [GITHUB_ICON]=$'\ue709'
     [GITHUB_ICON_ALT]=$'\ueb00'
     [GITHUB_ICON_ALT2]=$'\uea84'
    [FOLDER_ICON]=$'\uf07c'
    [LEGO_ICON]=$'\ue0b8'
    [DASH_ICON]=$'\uf48b'
    [CIRCLE_ICON]=$'\uf192'
    [RIGHT_ARROW]=$'\uf054'
    [LEFT_ARROW]=$'\uf053'
    [RIGHT_HALF_CIRCLE]=$'\ue0b4'
    [LEFT_HALF_CIRCLE]=$'\ue0b1'
    [RIGHT_SEPARATOR]=$'\ue0b2'
    [LEFT_SEPARATOR]=$'\ue0b0'
    [CIRCLE]=$'\ue0b0'
    [PATH_SEP]=$'\ue0b2'
    [CIRCLE_ALT2]=$'\ue0b2'
    [CIRCLE_ALT3]=$'\ue0b3'
)

CURRENT_BG='NONE'
SEGMENT_SEPARATOR_RIGHT='\ue0b2'
SEGMENT_SEPARATOR_LEFT='\ue0b0'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_segment_right() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    echo -n "%K{$CURRENT_BG}%F{$1}$SEGMENT_SEPARATOR_RIGHT%{$bg%}%{$fg%} "
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR_LEFT"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{yellow}%}✖"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

prompt_dir() {
  prompt_segment blue white '%~'
}

prompt_git_prompt() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)
  if [[ -n $branch ]]; then
    prompt_segment black default "$ICONS[GITHUB_ICON] $branch $(git_prompt_status_cwh)"
  fi
}

prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_git_prompt
  fi
}

function cwh_update_prompt() {
    prompt_status
    prompt_dir
    prompt_git
    prompt_end
}

PROMPT=$'%{%f%b%k%}\n$(cwh_update_prompt) '