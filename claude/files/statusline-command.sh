#!/bin/bash
# Claude Code status line.
#   LEFT : badges  cwd  +added -removed   (git working-tree change vs HEAD)
#   RIGHT: model  effort  (Nk)  · 5h P% (Tleft) · 7d P%
# The kilotoken count turns red once context usage passes 90%.
# Rate-limit windows are colored by *pace* — projecting current burn to the
# window reset (red if on track to exceed 100%, yellow >=90%, else green).

input=$(cat)

# winpath PATH — fold a Windows path into the POSIX form Git Bash uses
# (C:\code\kq and C:/code/kq both -> /c/code/kq). Untouched otherwise, so it is
# a no-op on Linux. Backslashes must go before the path reaches printf '%b'
# below, where \c silently truncates the line and \U aborts it.
winpath() {
    local p="$1" drive
    case "$p" in
        [A-Za-z]:[/\\]*)
            p="${p//\\//}"
            drive="${p:0:1}"
            p="/${drive,,}${p:2}"
            ;;
    esac
    printf '%s' "$p"
}

model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cwd=$(winpath "$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')")
project=$(winpath "$(echo "$input" | jq -r '.workspace.project_dir // empty')")

five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# ANSI colors — normal weight only (no bold, no dim) so it reads clearly. The
# PRODUCTION badge is the one exception: it exists to be impossible to miss.
RESET="\033[0m"
BADGE_PROD="\033[41;1;37m"
CYAN="\033[36m"
GREY="\033[90m"
LBLUE="\033[94m"
ORANGE="\033[38;5;208m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"

# effort_color LEVEL — ramps green (low) → red (max) with reasoning effort.
effort_color() {
    case "$1" in
        low) printf '%s' "$GREEN" ;;
        medium) printf '%s' "$CYAN" ;;
        high) printf '%s' "$YELLOW" ;;
        xhigh) printf '%s' "$MAGENTA" ;;
        max) printf '%s' "$RED" ;;
        *) printf '%s' "$CYAN" ;;
    esac
}

# pace_color USED RESETS_AT DURATION_SECONDS — linearly projects usage-so-far
# to the reset and colors by projected end-of-window total (red >=100%,
# yellow >=90%, else green); colors by raw usage if the reset is missing.
pace_color() {
    local used="$1" reset="$2" dur="$3" now start elapsed projected
    if [ -z "$reset" ]; then
        projected="$used"
    else
        now=$(date +%s)
        start=$(( reset - dur ))
        elapsed=$(( now - start ))
        [ "$elapsed" -lt 1 ] && elapsed=1
        [ "$elapsed" -gt "$dur" ] && elapsed=$dur
        projected=$(( used * dur / elapsed ))
    fi
    if [ "$projected" -ge 100 ]; then printf '%s' "$RED"
    elif [ "$projected" -ge 90 ]; then printf '%s' "$YELLOW"
    else printf '%s' "$GREEN"; fi
}

# time_left RESETS_AT — compact "1h59m" / "12m" until the window resets.
time_left() {
    local reset="$1" now secs h m
    [ -z "$reset" ] && return
    now=$(date +%s); secs=$(( reset - now ))
    [ "$secs" -lt 0 ] && secs=0
    h=$(( secs / 3600 )); m=$(( (secs % 3600) / 60 ))
    if [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"; else printf '%dm' "$m"; fi
}

# ---- Context badges ----
# Mirrors the shell prompt's badges (dotfiles zsh/.zshrc) so both surfaces answer
# "where am I" the same way: independent, so PRODUCTION and LIM can show at once.
# $LIMES_VERSION is set inside a limes sandbox; $PRODUCTION per-host in .zprofile.local.
# Each _plain entry must be as wide as what its _colored twin prints, trailing
# separator included — the layout below measures the plain string.
badge_plain=""
badge_colored=""
if [ -n "$PRODUCTION" ]; then
    badge_plain="${badge_plain} PRODUCTION  "
    badge_colored="${badge_colored}${BADGE_PROD} PRODUCTION ${RESET} "
fi
if [ -n "$LIMES_VERSION" ]; then
    badge_plain="${badge_plain}LIM "
    badge_colored="${badge_colored}${ORANGE}LIM${RESET} "
fi

# ---- LEFT: project path + relative cwd (when it differs) + git change count ----
left_plain=""
left_colored=""
base="${project:-$cwd}"
if [ -n "$base" ]; then
    # The ~ is escaped: bare, it would tilde-expand back to $HOME and no-op.
    dbase="$base"; [ -n "$HOME" ] && dbase="${base/#$HOME/\~}"
    left_plain="$dbase"
    left_colored="${GREY}${dbase}${RESET}"

    # Append cwd relative to the project root when you've cd'd below it.
    if [ -n "$project" ] && [ -n "$cwd" ] && [ "$cwd" != "$project" ]; then
        case "$cwd" in
            "$project"/*)
                rel="${cwd#"$project"/}"
                left_plain="${left_plain}/${rel}"
                left_colored="${left_colored}${LBLUE}/${rel}${RESET}" ;;
            *)  # cwd is outside the project root — show it in full instead
                dcwd="$cwd"; [ -n "$HOME" ] && dcwd="${cwd/#$HOME/\~}"
                left_plain="$dcwd"
                left_colored="${LBLUE}${dcwd}${RESET}" ;;
        esac
    fi

    # git working-tree change count (+added -removed vs HEAD) at the cwd.
    read -r added removed <<<"$(
        cd "${cwd:-$base}" 2>/dev/null && { git diff --numstat 2>/dev/null; git diff --cached --numstat 2>/dev/null; } \
        | awk '{ if ($1 ~ /^[0-9]+$/) a+=$1; if ($2 ~ /^[0-9]+$/) r+=$2 } END { print a+0, r+0 }'
    )"
    added="${added:-0}"; removed="${removed:-0}"
    if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
        left_plain="${left_plain} +${added} -${removed}"
        left_colored="${left_colored} ${GREEN}+${added}${RESET} ${RED}-${removed}${RESET}"
    fi
fi

left_plain="${badge_plain}${left_plain}"
left_colored="${badge_colored}${left_colored}"

# ---- RIGHT: model + context bar + tokens + rate limits ----
ktoken=""
[ -n "$tokens" ] && ktoken="$(( tokens / 1000 ))k"

right_plain="$model"
right_colored="${ORANGE}${model}${RESET}"

if [ -n "$effort" ]; then
    ec=$(effort_color "$effort")
    right_plain="${right_plain} ${effort}"
    right_colored="${right_colored} ${ec}${effort}${RESET}"
fi

if [ -n "$ktoken" ]; then
    kcolor="$ORANGE"
    if [ -n "$used" ]; then
        pct=$(printf "%.0f" "$used")
        [ "$pct" -ge 90 ] && kcolor="$RED"
    fi
    right_plain="${right_plain} (${ktoken})"
    right_colored="${right_colored} (${kcolor}${ktoken}${RESET})"
fi

# Plan rate-limit usage (Pro/Max only, after the first API response).
if [ -n "$five_used" ] || [ -n "$week_used" ]; then
    right_plain="${right_plain}  ·"
    right_colored="${right_colored}  ·"
    if [ -n "$five_used" ]; then
        u=$(printf "%.0f" "$five_used"); c=$(pace_color "$u" "$five_reset" 18000)
        t=$(time_left "$five_reset")
        seg="5h ${u}%"; [ -n "$t" ] && seg="${seg} (${t})"
        right_plain="${right_plain} ${seg}"
        right_colored="${right_colored} ${c}${seg}${RESET}"
    fi
    if [ -n "$week_used" ]; then
        u=$(printf "%.0f" "$week_used"); c=$(pace_color "$u" "$week_reset" 604800)
        [ -n "$five_used" ] && { right_plain="${right_plain} ·"; right_colored="${right_colored} ·"; }
        right_plain="${right_plain} 7d ${u}%"
        right_colored="${right_colored} ${c}7d ${u}%${RESET}"
    fi
fi

# Lay out: left segment, padding, right segment flush to the terminal's right
# edge. Claude Code captures stdout (so tput/width-detection can't see the tty)
# but sets $COLUMNS to the terminal width before running us (>= 2.1.153);
# default to 80 only if it's somehow unset.
term_width="${COLUMNS:-80}"
# The statusline render region is narrower than $COLUMNS (tmux/host offsets it
# from the left edge), so filling all of $COLUMNS pushes the right end
# off-screen. Reserve a few columns so the right segment stays visible.
avail=$(( term_width - 3 ))
pad=$(( avail - ${#left_plain} - ${#right_plain} ))
[ "$pad" -lt 1 ] && pad=1

printf "%b%${pad}s%b\n" "$left_colored" "" "$right_colored"
