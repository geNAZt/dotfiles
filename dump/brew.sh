#!/bin/bash
# brew-sync: The MacBook Air Rebuild Maintenance Script

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔄 Step 1: Updating Homebrew and Upgrading Packages..."
brew update && brew upgrade

echo "📝 Step 2: Updating the Brewfile from current state..."
# --describe adds comments explaining what each package is
# --force overwrites the existing ~/.Brewfile
brew bundle dump --force --describe --file="$HOME/.Brewfile"

echo "🏠 Step 3: Syncing with Chezmoi..."
# This copies ~/.Brewfile to ~/.local/share/chezmoi/dot_Brewfile
chezmoi add "$HOME/.Brewfile"


echo "🧹 Step 5: Final Cleanup (Removing unused dependencies)..."
brew autoremove
brew cleanup

echo "✨ Setup sync complete! Your MacBook Air is now 'cattle,' not a 'pet'."