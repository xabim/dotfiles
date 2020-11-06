#!/bin/user/env bash

install_macos_docopts() {
  sudo curl -L "https://github.com/docopt/docopts/releases/download/v0.6.3-rc2/docopts_darwin_amd64" --output /usr/local/bin/docopts
  sudo chmod a+x /usr/local/bin/docopts
}

install_linux_docopts() {
  echo "Linux support not added yet."
}

if platform::is_macos; then
  log::note "🍎 Installing MacOS docopts"

  install_macos_docopts "$network_computer_name"
fi

if platform::is_linux; then
  log::note "🐧 Installing Linux docopts"

  install_linux_docopts
fi
