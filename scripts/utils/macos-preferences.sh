
execute "defaults write com.apple.dock autohide -bool true" "Automatically hide and show the Dock"

execute "defaults write com.apple.dock autohide-delay -float 0" "Remove the auto-hiding Dock delay"

execute "defaults write com.apple.dock autohide-time-modifier -float 0" "Remove the animation when hiding/showing the Dock"

# settings based on https://mac-key-repeat.zaymon.dev/
execute "defaults write NSGlobalDomain KeyRepeat -int 1" "Keyboard: Set 15 ms key repeat"

execute "defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false" "Keyboard: Disable tooltip when holding key"

execute "defaults write NSGlobalDomain AppleShowAllExtensions -bool true" "Show all filename extensions"

execute "defaults write NSGlobalDomain InitialKeyRepeat -int 13" "Keyboard: Set 195 ms initial delay"

execute "defaults write com.apple.dock show-process-indicators -bool false" "Don't show indicator for running Apps"

execute "defaults write com.apple.dock show-recents -bool false" "Don't show recent applications in Dock"

# Configure apps on Dock
# execute "defaults write com.apple.dock persistent-apps -array" "Remove all persistent apps from dock"

# addAppToDock "Launchpad"
# addAppToDock "Zen"
# addAppToDock "Ghostty"
# addAppToDock "Obsidian"
# addAppToDock "Visual Studio Code"
