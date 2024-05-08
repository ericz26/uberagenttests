#!/bin/bash

# Get the logged in user
loggedInUser=$(w -h | awk '{print $1}' | head -n1)

# Get the list of Google Chrome profiles
profiles="/Users/$loggedInUser/Library/Application Support/Google/Chrome/Default"'\n'
profiles+=$(find "/Users/$loggedInUser/Library/Application Support/Google/Chrome" -type d -name 'Profile*')


# Loop through each profile
for profile_path in $profiles; do
    #profile_path="$HOME/Library/Application Support/Google/Chrome/$profile"
    
    # Check if the profile directory exists
    if [ -d "$profile_path" ]; then
        # Output Profile Name
        echo "Profile Path=$profile_path"

        # Get the list of installed extensions
        extensions=$(ls "$profile_path/Extensions")

        # Loop through each extension
        for extension in $extensions; do
            # Field data

            # Get the ExtensionId from the manifest file
            extensionId=$extension

            extensionName==$(cat "$profile_path/Extensions/$extension/manifest.json" | grep -o '"name":.*' | sed 's/.*: "\(.*\)".*/\1/')
            
            # Get the ExtensionVersion from the manifest file
            extensionVersion=$(cat "$profile_path/Extensions/$extension/manifest.json" | grep -o '"version":.*' | sed 's/.*: "\(.*\)".*/\1/')

            # Get the Permissions from the manifest file
            extensionPermissions=$(cat "$profile_path/Extensions/$extension/manifest.json" | grep -o '"permissions":.*' | sed 's/.*: "\(.*\)".*/\1/')


            output = $(OsUser="$loggedInUser" Browser="Google" ProfileDir="$profile_path" ProfileName="$profile" ProfileGaiaName="$profile" ExtensionId="$extensionId" ExtensionName="$extensionName" ExtensionVersion="$extensionVersion" extensionPermissions="$extensionPermissions")
            
            # Output 
            echo $output
        done        
    fi
done


#find "/Users/$loggedInUser/Library/Application\ Support/Google/Chrome/Profile\ */Extensions" -type f -name "manifest.json" -print0 | xargs -I {} -0 grep '"name":' "{}" | uniq
#find "/Users/$loggedInUser/Library/Application\ Support/Google/Chrome/Profile\ */Extensions" -type f -name "manifest.json" -print0 | xargs -0 grep -E '"name"|"extensionId"|"version"' | uniq
