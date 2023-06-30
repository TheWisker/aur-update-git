#!/bin/bash

for folder in $aur_folder/*/; do
    folder_name=$(basename "${folder}")
    # Only run if it is a pkgbase-git aur package
    if [[ $folder_name == *-git ]]; then
        #Check if PKGBUILD file exists in the folder
        if [[ -f "${folder}PKGBUILD" ]]; then
            pkgrel_line=$(grep -e '^pkgrel=' "${folder}PKGBUILD")
            # Extract the current pkgrel value
            current_pkgrel=$(echo "$pkgrel_line" | cut -d '=' -f2)
            new_pkgrel=$((current_pkgrel + 1))
            # Replace the pkgrel value with the updated one
            sed -i "s/^pkgrel=.*/pkgrel=$new_pkgrel/" "${folder}PKGBUILD"
            echo "Updated pkgrel to $new_pkgrel in ${folder}PKGBUILD"
        fi
        #Check if .SRCINFO file exists in the folder
        if [[ -f "${folder}.SRCINFO" ]]; then
            if ! [ -v new_pkgrel ]; then
                pkgrel_line=$(grep -e '^[[:space:]]*pkgrel =' "${folder}.SRCINFO")
                # Extract the current pkgrel value
                current_pkgrel=$(echo "$pkgrel_line" | awk -F ' = ' '{print $2}')
                new_pkgrel=$((current_pkgrel + 1))
            fi
            # Replace the pkgrel value with the updated one
            sed -i "s/^\([[:space:]]*pkgrel =\).*/\1 $new_pkgrel/" "${folder}.SRCINFO"
            echo "Updated pkgrel to $new_pkgrel in ${folder}.SRCINFO"
        fi
    fi
done