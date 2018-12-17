#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System Preferences > Sharing                                                #
###############################################################################

ComputerName="shadowcat"

# Set computer name
sudo scutil --set ComputerName $ComputerName
sudo scutil --set HostName $ComputerName
sudo scutil --set LocalHostName $ComputerName
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $ComputerName

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
sudo systemsetup -settimezone "Europe/Amsterdam" > /dev/null

# Swap left and right mouse buttons
defaults -currentHost write -g com.apple.mouse.swapLeftRightButton -int 1

# disable Siri
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnable -bool true
defaults write com.apple.assistant.support 'Assistant Enabled' 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Disable Notification Center Swipe
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 3
defaults write com.apple.keyboard.fnState -bool false

###############################################################################
# System Preferences > Users & Groups                                         #
###############################################################################

# Disallow guests to log in to this computer
sudo defaults write /Library/Preferences/com.apple.loginwindow 'GuestEnabled' -bool false

# Hide the Sleep, Restart, and Shut Down buttons
sudo defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool true

# Hide Input menu in login window
sudo defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool false

# Hide password hints
sudo defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: hide tags
defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true


###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true


# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0


###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Start with all windows from last session
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true

# Setup new window and tab behvior
# 0: Homepage
# 1: Empty Page
# 2: Same Page
# 3: Bookmarks
# 4: Top Sites
defaults write com.apple.Safari NewTabBehavior -int 1
defaults write com.apple.Safari NewWindowBehavior -int 1

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Ask websites not to track me
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Enable the Develop menu and the Web Inspector
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true

# Enable the Develop menu and the Web Inspector in Safari
# Set home page to 'about:blank'

###############################################################################
# Calculator                                                                  #
###############################################################################

# View mode
#   - Basic
#   - Scientific
#   - Programmer
defaults write com.apple.calculator ViewDefaultsKey -string "Scientific"

# Show Thousands Separator
defaults write com.apple.calculator SeparatorsDefaultsKey -bool true

###############################################################################
# Menu bar                                                                   #
###############################################################################

# items: Keychain, Timemachine, Bluetooth, AirPort, Volume, Battery, Clock
defaults write com.apple.systemuiserver menuExtras -array "/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu" "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Volume.menu" "/System/Library/CoreServices/Menu Extras/Battery.menu" "/System/Library/CoreServices/Menu Extras/Clock.menu"

###############################################################################
# Kill affected applications                                                  #
###############################################################################

# clear the preference cache
sudo killall -HUP cfprefsd

for app in "Dock" "Finder" "Calculator" "Dashboard" "SystemUIServer" "Safari" ; do
	killall "${app}" &> /dev/null
done
