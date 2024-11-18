#!/bin/bash

set -oxeu pipefail

echo "Adding desktop packages"

# Define repos with ["filename"]="repo_url"
declare -Ar REPOS=(
    ["gh-cli"]="https://cli.github.com/packages/rpm/gh-cli.repo"
)

# Packages to install
PACKAGES=(
	gh
	btop
)

# Prefer vim over nano as default editor
dnf5 swap -y nano-default-editor vim-default-editor --allowerasing

echo "Adding the needed repositories"
for repo in "${!REPOS[@]}"; do
    dnf5 config-manager addrepo --from-repofile="${REPOS[$repo]}" --save-filename="${repo}"
done

echo "Installing packages"
dnf5 install -y "${PACKAGES[@]}"

echo "Removing the installed repositories"
for repo in "${!REPOS[@]}"; do
    rm -f /etc/yum.repos.d/"${repo}".repo
done
