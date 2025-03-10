#!/bin/bash

# Install Alectrona Patch

# Installs the latest release of Alectrona Patch

# Created by Alectrona at https://github.com/alectrona/alectrona-patch-resources

uuid=$(/usr/bin/uuidgen)
workDir="/private/tmp/$uuid"
unset version

function clean_up () {
    echo "Cleaning up installation files..."
    /bin/rm -Rf "$workDir"
}

# Clean up our temporary files upon exiting at any time
trap clean_up EXIT

# Make our working directory with our unique UUID generated in the variables section
/bin/mkdir -p "$workDir"

# Exit if there was an error with the curl
echo "Downloading the installation files..."
if ! /usr/bin/curl -s -L -f https://software.alectrona.com/patch/releases/alectrona-patch-latest.pkg -o "$workDir/alectrona-patch.pkg" ; then
    echo "Error while downloading the installation files; exiting."
    exit 1
fi

# Exit if the PKG errored during install
if ! /usr/sbin/installer -pkg "$workDir/alectrona-patch.pkg" -target / ; then
    echo "Failed to install the pkg; exiting."
    exit 2
fi

# Determine the version of patch
if [[ -e /Library/Application\ Support/Alectrona/Patch/patch ]]; then
    version=$(/Library/Application\ Support/Alectrona/Patch/patch --version 2> /dev/null)
else
    version=$(/usr/local/bin/patch --version 2> /dev/null)
fi

# Exit if we can't determine the version of patch
if [[ -n "$version" ]]; then
    echo "Successfully installed Alectrona Patch version $version."
else
    echo "Failed to successfully install Alectrona Patch; exiting."
    exit 3
fi

exit 0