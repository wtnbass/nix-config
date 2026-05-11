#!/bin/sh
# Claude Code status line — inspired by hydro theme
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

short_dir=$(basename "$cwd")

# Build prompt parts
prompt=""

# cwd
prompt="${prompt} $(printf '\033[34m%s\033[0m' "$short_dir")"

# git branch
if [ -n "$git_branch" ]; then
    prompt="${prompt} $(printf '\033[32m(%s)\033[0m' "$git_branch")"
fi

# model
if [ -n "$model" ]; then
    prompt="${prompt} $(printf '\033[33m[%s]\033[0m' "$model")"
fi

# context window usage
if [ -n "$used" ]; then
    used_int=$(printf '%.0f' "$used")
    prompt="${prompt} $(printf '\033[35mctx:%s%%\033[0m' "$used_int")"
fi

# rate limits
rate_str=""
if [ -n "$five" ]; then
    five_int=$(printf '%.0f' "$five")
    rate_str="${rate_str}5h:${five_int}%"
fi
if [ -n "$week" ]; then
    week_int=$(printf '%.0f' "$week")
    if [ -n "$rate_str" ]; then
        rate_str="${rate_str} 7d:${week_int}%"
    else
        rate_str="7d:${week_int}%"
    fi
fi
if [ -n "$rate_str" ]; then
    prompt="${prompt} $(printf '\033[31m[%s]\033[0m' "$rate_str")"
fi

printf '%s' "$prompt"
