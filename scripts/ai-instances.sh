#!/bin/bash
# List all active Claude Code and OpenCode instances with their working directories

BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
RESET='\033[0m'

print_instances() {
    local name="$1"
    local icon="$2"
    local pids="$3"

    if [ -z "$pids" ]; then
        echo -e "${DIM}No active ${name} instances found.${RESET}"
        echo
        return
    fi

    count=$(echo "$pids" | wc -l)
    echo -e "${BOLD}${CYAN}${icon} ${name} Instances${RESET} ${DIM}(${count} active)${RESET}"
    echo -e "${DIM}─────────────────────────────────────────────────────────────${RESET}"
    printf "${BOLD}%-8s %-8s %-10s %s${RESET}\n" "PID" "TTY" "TIME" "WORKING DIRECTORY"
    echo -e "${DIM}─────────────────────────────────────────────────────────────${RESET}"

    for pid in $pids; do
        tty=$(ps -o tty= -p "$pid" 2>/dev/null)
        time=$(ps -o time= -p "$pid" 2>/dev/null)
        cwd=$(readlink /proc/"$pid"/cwd 2>/dev/null)
        printf "${GREEN}%-8s ${YELLOW}%-8s ${MAGENTA}%-10s ${CYAN}%s${RESET}\n" "$pid" "$tty" "$time" "$cwd"
    done
    echo
}

claude_pids=$(pgrep -x claude)
opencode_pids=$(pgrep -x opencode)

print_instances "Claude" "" "$claude_pids"
print_instances "OpenCode" "" "$opencode_pids"
