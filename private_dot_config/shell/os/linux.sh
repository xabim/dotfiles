# -----------------
# Linux Specific Configuration
# -----------------

# Linux specific aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'

# Linux specific functions

# Create a directory and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Show system information
function sysinfo() {
  echo "System Information:"
  echo "==================="
  echo "Hostname: $(hostname)"
  echo "OS: $(lsb_release -d | cut -f2)"
  echo "Kernel: $(uname -r)"
  echo "Architecture: $(uname -m)"
  echo "Uptime: $(uptime -p)"
  echo "Memory: $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
  echo "Disk Usage: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
}

# Quick server
function serve() {
  local port=${1:-8000}
  python3 -m http.server $port
}
