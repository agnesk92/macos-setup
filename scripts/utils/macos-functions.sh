
# Add an Application to the macOS Dock
# - usage: addAppToDock "[Application Name]"
# - example: addAppToDock "Terminal"
# Source: https://github.com/rpavlick/add_to_dock
function addAppToDock() {
    local app_name="$1"
    local launchservices_path="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
    local app_path=$($launchservices_path -dump | grep -o "/.*$app_name.app" | grep -v -E "Backups|Caches|TimeMachine|Temporary|/Volumes/$app_name" | uniq | sort | head -n1)
    if open -Ra "$app_path"; then
       defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    else
       showinfo "Application not found: $1\n$app_path" "error"
    fi
}
export -f addAppToDock
