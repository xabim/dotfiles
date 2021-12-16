# 🚀 xabim dotfiles

> 🐢   💨 Speedup your MacOS setup with this fine tuning settings

Repository containing all the automation required to setup your MacOS in just a few seconds after a fresh install.

Feel free to explore the repository and get anything you need 😬

## 📜 Table of Contents

* [🚀 Installation](#-installation)
* [✍️ Repository Contents](#-repository-contents)
    * [💻 Shell dotfiles](#-shell-dotfiles)
    * [🐙 Git dotfiles](#-git-dotfiles)
    * [⚡ Custom commands](#-custom-commands)
    * [📱 Other apps dotfiles](#-other-apps-dotfiles-and-settings)
    * [🤖 Shell scripts](#-shell-scripts)
        * [🍎 `install_macos_apps.sh`](#-install_macos_appssh))
        * [🎛️ `adjust_macos_settings.sh`](#-adjust_macos_settingssh)
            * [🤔 How to discover new domains and settings](#-how-to-discover-new-domains-and-settings)
            * [🏃‍♂️ How to automate settings changes](#️-how-to-automate-settings-changes)
    * [👷‍♂️ Work scripts](#️-work-scripts)
* [ℹ️ About](#ℹ️-about)
* [🤝 Contributing](#-contributing)
    * [☑️ ToDo suggestions](#️-todo-suggestions)
* [⚖️ License](#️-license)

## 🚀 Installation

Execute the [`installer`](installer) from your terminal in order to avoid even having to manually install git!

```bash
bash <(curl -s https://raw.githubusercontent.com/xabim/dotfiles/master/installer)
```

If you want to check out all the details involved in a migration from a legacy to a new PC, you can checkout the [`installation-guide.md`](doc/installation-guide.md)
You'll find some self-explanatory files in this repo containing comments on what they do, however, here you have a brief explanation of each on of them.

### 💻 Shell dotfiles

* [`_aliases`](terminal/_aliases): Common command aliases in order to save some characters 😬
* [`_functions`](terminal/_functions): Common shell functions (key difference from `.aliases`: functions will receive an argument)
* [`_exports`](terminal/_exports): Exports for variables
* [`bash`](terminal/bash): Main config for Bash shell
* [`zsh`](terminal/zsh): Main config for ZSH shell


### 🐙 Git dotfiles

* [`.gitconfig`](git/.gitconfig): Different settings for the Git CSV system such as including the following file
* [`.gitignore_global`](git/.gitignore_global): Ignore rules to apply to every single repository (usefull to do not mess up the project `.gitignore` file with particularities of your development environment such as the `.DS_Store` files or your IDE settings)
* [`.gitattributes`](git/.gitattributes): Simple text file that gives attributes to pathnames

### ⚡ Custom commands

These are custom commands defined in [binary files](bin) with little scripts to boost your productivity in your daily basis tasks:

These binaries are installed thanks to adding [the binary files directory](bin) to the `PATH` environment variable in the  [`.profile`](.profile) file.

* [`bin/dot`](bin/dot): Lists your scripts/tools inside [scripts](scripts) folder in a fancy way with fzf

### 🤖 Shell scripts / Functions

#### 🍎 [`install_macos_custom()`](self/install/install.sh)

This function will install Comand Line Developer Tools also [Homebrew](https://brew.sh/). It's a package manager for MacOS, used to install some tools like `htop`, `ffmpeg`, `git`, `php`… you get the idea, Command Line Tools, programming languages, and so on.

Homebrew also includes [Homebrew Cask](http://caskroom.io/). It's a package manager useful to install fully functional OS X applications such as `google-chrome`, `spotify`, `slack`…

With these 2 command line tools, we'll be able to install and upgrade our apps without having to leave the terminal. This allow us to automate the whole setup process while starting clean on a new mac, and also to do not have to open all the different apps we've installed in order to update them.

You can [check out the `install_macos_custom` function](self/install/install.sh) in order to see the detailed list of the apps it will install, and modify it based on your needs, and [the available packages in Homebrew](https://formulae.brew.sh/formula/) and [Homebrew Cask apps](https://github.com/Homebrew/homebrew-cask/tree/master/Casks). The list of packages are at [Brewfile](mac/brew/Brewfile)

#### 🎛️ [`mac-os.sh`](mac-os.sh)

This script will modify system preferences. We would recommend you to [take a look at the `mac-os.sh` script](mac/configs/mac-os.sh) in order to know the actual list of aspects it will modify. Here you have a brief list of them:

* Dock: Automatically hide the dock with a fewer delay and animation times
* Mission Control: Add Hot corners behaviour and reduce the animation time
* Keyboard: Reduce the delay for repeating a key while pressed, and the time between repetitions of that key
* Mouse: Increase its speed
* Trackpad: Enable tap to click for the current user and for the login screen. (Don't have to press down on the trackpad -- just tap it.)
* Finder: Disable animations + show extensions + set columns as default view + show pathbar + enable [spring-loading directories](https://www.youtube.com/watch?v=F9kdAxGe9SE)…
* Safari & WebKit: Allow hitting the Backspace key to go to the previous page + show full URL + disable automatic spelling corrections…
* Others: Disable the sound effects on boot + always show scrollbars + disable automatic capitalization + Avoid creating .DS_Store files on network or USB volumes + Maximize windows with `Ctrl+alt+Cmd+f`…

##### 🤔 How to discover new domains and settings

You can explore your current settings on all the different applications just with a few commands:

* List all config domains you have: `defaults domains | tr ',' '\n'`
* List the current settings for a specific domain: `defaults read com.apple.finder`
* Read the type of the setting you want to modify: `defaults read-type com.apple.finder NewWindowTargetPath`
* Write your new value for the setting: `write com.apple.finder NewWindowTargetPath "file:///Users/your-username/"`

##### 🏃‍♂️ How to automate settings changes

The problem with the previous approach is that it could be a little verbose while showing you aaaaall the different settings an application has. So here's a quick tip on how to optimize the process for these settings which can be adjusted using the UI:

* Save the output of your current settings into a file: `defaults read > defaults_before_ui_changes.json`
    * Pro tip: If you already know the domain of the settings you're going to modify, optimize the size of the output specifying so: `defaults read com.apple.finder > finder_defaults_before_ui_changes.json`
* Modify the settings through the UI
* Save the output of the modified settings: `defaults read > defaults_after_ui_changes.json`
    * Alternatively: `defaults read com.apple.finder > finder_defaults_after_ui_changes.json`
* Compare the `before` and `after` files to see what settings has been modified: `diff defaults_before_ui_changes.json defaults_after_ui_changes.json`
    * Alternatively: `diff finder_defaults_before_ui_changes.json finder_defaults_after_ui_changes.json`
    * Pro tip: If the `diff` doesn't provide you enough context, you can run it with `diff -C 10` option to show 10 lines before and after each difference
    * Pro tip 2: If the `diff` output is a mess for you, you can open it with VS Code with `code --diff finder_defaults_before_ui_changes.json finder_defaults_after_ui_changes.json`
* Save the modified keys and construct your `write` commands in order to automate it the next time. For instance: `write com.apple.finder NewWindowTargetPath "file:///Users/your-username/"`

### 👷‍♂️ Work scripts

If you need to use private scripts for your work computer, you can just create a folder `.dotfiles_work` at `$HOME` and clone there the private repository from your internal source control, and add in this folders sources:

* [`_aliases`](terminal/_aliases): Common command aliases in order to save some characters 😬
* [`_functions`](terminal/_functions): Common shell functions (key difference from `.aliases`: functions will receive an argument)
* [`_exports`](terminal/_exports): Exports for variables

Also there is a script called `dotw` to use script for work, all scripts will be places under `scripts` folder

* [`bin/dotw`](bin/dotw): Lists your scripts/tools inside [scripts](scripts) folder in a fancy way with fzf

## ℹ️ About

This hopefully helpful repository has been developed by [xabim](https://github.com/xabim) based on CodelyTV doftiles repository and [CodelyTV](https://github.com/CodelyTV/dotfiles).

We've used a lot of different sources to get some inspirations on the things to do, here you have a list of them:

* https://hackernoon.com/personal-macos-workspace-setup-adf61869cd79
* https://pawelgrzybek.com/change-macos-user-preferences-via-command-line
* https://defaults-write.com
* https://wilsonmar.github.io/dotfiles/
* https://github.com/alexramirez/mac-setup
* https://github.com/alrra/dotfiles
* https://github.com/boochtek/mac_config/blob/master/trackpad.sh
* https://github.com/dstroot/.osx
* https://github.com/mathiasbynens/dotfiles/blob/master/.macos
* https://github.com/MoOx/setup
* https://github.com/pawelgrzybek/dotfiles/blob/master/setup-macos.sh
* https://github.com/rgomezcasas/dotfiles
* https://github.com/sindresorhus/quick-look-plugins

## 🤝 Contributing

So please, feel free to send us your tips and tricks [opening an issue](https://github.com/xabim/dotfiles/issues) before starting to work on a Pull Request 🙂

### ☑️ ToDo

* Move the things already specified in the [`installation-guide.md`](doc/installation-guide.md) to automations. How to procedure:
  * Search for the application `plist` files. In [this repo](https://github.com/lra/mackup/blob/master/mackup/applications/) there're a lot of supported applications which specify the config paths.
  * Move the `plist` files to this repo in case of not containing sensitive data
  * Create the symlink between the application `plist` file and this repo
  * Specify the symlink in the [`conf.macos.yaml`](symlinks/conf.macos.yaml) file mapping

## ⚖️ License

The MIT License (MIT). Please see [License](LICENSE) for more information.
