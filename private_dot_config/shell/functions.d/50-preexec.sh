# Function to check if the executed command is an alias expansion
# $1: The command line as entered (unexpanded)
# $3: The expanded command line (including alias expansion)
# Controlled by environment variable: SHOW_ALIAS_EXPANSION (default: 1)
# Also supports inline usage: SHOW_ALIAS_EXPANSION=0 command
function print_expanded_alias() {
  local original_command="$1"
  local expanded_command="$3"

  # Check if SHOW_ALIAS_EXPANSION is set inline in the command
  local show_expansion="${SHOW_ALIAS_EXPANSION:-1}"
  if [[ "$original_command" =~ ^SHOW_ALIAS_EXPANSION=([^[:space:]]+) ]]; then
    show_expansion="${match[1]}"
  fi

  # Check if alias expansion printing is disabled
  if [[ "$show_expansion" != "1" ]]; then
    return
  fi

  # Check if the commands are different and the expanded command is not empty
  if [[ -n "$expanded_command" && "$original_command" != "$expanded_command" ]]; then
    # Get the command name before any arguments/options
    local cmd_name="$(echo "$original_command" | awk '{print $1}')"

    # Check if the command name is a defined alias (and not a function or builtin)
    if alias "$cmd_name" &>/dev/null; then
      # Print the expanded alias. Using print -P for Zsh's prompt expansion features
      # You can customize the look here (e.g., color/format)
      print -P "%B%F{yellow}❯ Alias Expansion:%f%b $expanded_command"
    fi
  fi
}