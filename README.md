# Dotfiles with Chezmoi

This repository contains my personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Quick Setup

1. **Install chezmoi:**
   ```bash
   brew install chezmoi
   ```

2. **Initialize and apply dotfiles:**
   ```bash
   chezmoi init --apply https://github.com/your-username/dotfiles.git
   ```

## Configuration

The dotfiles support different configurations based on environment:

- **Personal setup** (default): Includes personal applications and configurations
- **Work setup**: Excludes personal applications, includes only work-appropriate tools

### Setting up for work environment

```bash
chezmoi init --data isWork=true https://github.com/your-username/dotfiles.git
chezmoi apply
```

## What's included

- **Shell configuration**: Enhanced zsh with plugins, aliases, and functions
- **Git configuration**: Global gitignore and gitattributes
- **Homebrew packages**: Curated list of CLI tools and applications
- **macOS configuration**: System preferences and optimizations
- **Development tools**: Go environment, various CLI utilities

## Managing dotfiles

```bash
# Apply changes
chezmoi apply

# Edit a file
chezmoi edit ~/.zshrc

# Add a new file
chezmoi add ~/.newfile

# Check what would change
chezmoi diff

# Update from source
chezmoi update
```

## File structure

- `dot_*` - Files that start with a dot in your home directory
- `private_dot_config/` - Files in `~/.config/` directory
- `*.tmpl` - Template files that use chezmoi's templating
- `run_once_*` - Scripts that run once during setup

For more information, see the [chezmoi documentation](https://www.chezmoi.io/).
