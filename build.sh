#!/bin/bash

set -ouex pipefail

rsync -rvK /ctx/system_files/ /

echo "Running build"
/ctx/build_files/branding.sh
/ctx/build_files/desktop-changes.sh
