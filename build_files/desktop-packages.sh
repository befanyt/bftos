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
)

# dnf5 will be on F41 by default, can be removed when stable moves to it
rpm-ostree install dnf5 dnf5-plugins

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
