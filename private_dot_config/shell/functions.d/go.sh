#### 🐹 Go functions
gcover() { go test ./... -coverprofile=cover.out && go tool cover -html=cover.out; }
gwatch() {
  if command -v watchexec >/dev/null; then
    watchexec -e go -r -- go test ./...
  elif command -v entr >/dev/null; then
    fd '\.go$' | entr -r go test ./...
  else
    echo "Install watchexec or entr to use gwatch"; return 1
  fi
}