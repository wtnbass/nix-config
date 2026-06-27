#!/bin/sh

set -eu

keep_generations="${CLEAN_KEEP_GENERATIONS:-5}"
system_profile="${SYSTEM_PROFILE:-/nix/var/nix/profiles/system}"
profile_name="$(basename "$system_profile")"
profile_dir="$(dirname "$system_profile")"

case "$keep_generations" in
  ''|*[!0-9]*)
    echo "CLEAN_KEEP_GENERATIONS must be a positive integer: $keep_generations" >&2
    exit 1
    ;;
esac

if [ "$keep_generations" -lt 1 ]; then
  echo "CLEAN_KEEP_GENERATIONS must be greater than 0: $keep_generations" >&2
  exit 1
fi

if [ ! -L "$system_profile" ]; then
  echo "System profile is not a symlink: $system_profile" >&2
  exit 1
fi

current="$(
  readlink "$system_profile" \
    | sed -n "s/.*${profile_name}-\([0-9][0-9]*\)-link.*/\1/p"
)"

if [ -z "$current" ]; then
  echo "Could not determine current generation from $system_profile" >&2
  exit 1
fi

delete_until=$((current - keep_generations))

if [ "$(id -u)" = 0 ]; then
  sudo_cmd=""
else
  sudo_cmd="sudo"
fi

if [ "$delete_until" -gt 0 ]; then
  generations=""

  for link in "$profile_dir"/"$profile_name"-*-link; do
    [ -L "$link" ] || continue

    generation="$(
      basename "$link" \
        | sed -n "s/^${profile_name}-\([0-9][0-9]*\)-link$/\1/p"
    )"

    if [ -n "$generation" ] && [ "$generation" -le "$delete_until" ]; then
      generations="$generations $generation"
    fi
  done

  if [ -n "$generations" ]; then
    echo "Deleting old system generations:$generations"
    # shellcheck disable=SC2086
    $sudo_cmd nix-env --profile "$system_profile" --delete-generations $generations
  else
    echo "No old system generations to delete"
  fi
else
  echo "Keeping all system generations: current=$current keep=$keep_generations"
fi

$sudo_cmd nix-store --gc
