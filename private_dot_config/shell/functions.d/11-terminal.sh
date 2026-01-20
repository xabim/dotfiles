term-bg-relax() {
  local color="#2d332a"

  printf "\x1b]11;%s\x1b\\" "$color"
}

term-bg-red() {
  local color="#421e1e"
  local title="⚠️ ALERT ⚠️"

  printf "\x1b]11;%s\x1b\\" "$color"
  printf "\033]2;%s\007" "$title"
}

term-bg-reset() {
  local title="WezTerm"

  printf "\x1b]111\x1b\\"
  printf "\033]2;%s\007" "$title"
}