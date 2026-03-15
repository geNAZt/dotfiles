#!/bin/bash

# Enable Dock autohide
defaults write com.apple.dock autohide -bool true

# 2026 Pro-Tip: Speed up the animation
# By default, macOS has a slight delay before the Dock shows up.
# These two commands make the hover feel instant—perfect for a fast workflow.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Apply the changes
killall Dock
