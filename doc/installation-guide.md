# Installation Guide

## Legacy computer

Copy from the previous computer before The Shutdown™:

* Data not included in this repo:
  * `~/Library/Fonts`
  * `~/.ssh`
  * `~/.gnupg`
  * `~/Code`
* Slack workspaces list
* Copy Macos Keyboard shortcut preferences

## New computer

* Log in iCloud and Sync all Keychain passwords
* Update MacOS
* Paste the directories with data not included in this repo
* `chmod -R 700 ~/.ssh`
* `chmod -R 700 ~/.gnupg`
* Execute the dotfiles installer:
  * `bash <(curl -s https://raw.githubusercontent.com/codelytv/dotfiles/master/installer)`
  * If any dialog appears regarding to not being able to install something, check in "System Preferences… > Security & Privacy" if you have to manually approve it.
  * If there's any error and you want to execute again the cloned dotfiles:
     1. `export DOTFILES_PATH="$HOME/.dotfiles"`
     2. `.dotfiles/bin/dot" self install`
* Give permission to Finder Quick Look plugins
  * `open ~/Library/Quicklook/QLStephen.qlgenerator/Contents/MacOS/QLStephen`
  * Go to Security settings and allow it
  * `open ~/Library/QuickLook/QLColorCode.qlgenerator`
  * Go to Security settings and allow it
* Open Google Backup and Sync
  * Disable "USB Devices & SD Cards"
  * Open the settings and configure them as follow:
    * My Computer:
      * Disable the backup of any folder
      * Google Drive: Always remove both copies
      * Google Photos: Disable the upload of newly added photos
    * Google Drive:
      * Enable selective sync from Google Drive to the computer
    * Settings:
      * Disable "Show warning when you remove…"
* Open Google Chrome
  * Login to the personal profile and sync
  * Add the work profile and sync
  * Authenticate all the extensions
  * For each profile: Go to History > Show Full History > Tabs from other devices > Open All
* Open Magnet
  * Give permissions
  * Check Launch at login
  * Open Preferences and remove shortcuts for corner, third, and center positions
* Open Rocket
  * Give permissions
  * Preferences > General
    * Start Rocket at Login
    * Trigger key: §
    * Remove all app exceptions
  * Preferences > Advanced
    * Remove all website exceptions
  * Configure license
    * Type anywhere something like "§blablabla"
    * Browse all emoji…
    * Enter activation number
* Open Spotify
  * Disable automatic startup
  * Download some playlist
* Open Authy and login
* Open iTerm
  * Select load preferences from URL and use ~/.dotfiles/mac/iTerm. On the next prompt select "NOT copy"
  * Restart iTerm
* Open Slack
  * Login to the same workspaces
* Check Energy Saver preferences and disable menu bar icon
* Check Date and Time preferences and disable menu bar icon
* Open Monosnap
  * General:
    * Launch at login
  * Hotkeys:
    * Capture area: `Cmd+Shift+Option+5`
    * Capture frozen area: `Cmd+Shift+Option+6`
    * Capture area & Upload: `Not set`
    * Capture fullscreen: `Cmd+Shift+Option+7`
    * Fullscreen after 10s: `Cmd+Shift+Option+8`
    * Open last image: `Cmd+Shift+Option+0`
  * Account: Sign in
  * Try to take a capture in order to trigger the permissions dialog
* Restart
* Execute `dot shell zsh reload_completions` and then `compinit`
* Stop `mariadb` service making it to not start on system start up: `brew services stop mariadb`
* Once the Google Drive folder has been sync: `ln -s ~/Pictures/Wallpapers ~/Google\ Drive/📸\ Photos/Wallpapers\ en\ uso/`
