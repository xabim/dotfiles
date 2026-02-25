fzj() {
  cat /dev/stdin | jq -c '.[]?' | fzf \
    --ansi \
    --reverse \
    --height=50% \
    --preview "echo {} | jq -C '.'" \
    --preview-window=right:60%:wrap \
    --header "Search and press enter to view details"
}

fjq() {
  local temp=$(mktemp)
  cat /dev/stdin > "$temp"

  local query=$(echo '' | fzf \
      --print-query \
      --preview "jq -C {q} $temp 2>/dev/null || echo 'Waiting for a valid filter...'" \
      --preview-window=up:90% \
      --header "Write the jq filter (e.g., .[0].name) and press ENTER" | tail -1)

  if [ -n "$query" ]; then
    jq "$query" "$temp"
  fi

  rm "$temp"
}
