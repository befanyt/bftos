#!/bin/bash

set -oxeu pipefail

echo "Changing desktop configuration"

# Test gschema override for errors. 
mkdir -p /tmp/bftos-schema-test
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/bftos-schema-test/ \;
cp /usr/share/glib-2.0/schemas/*-bftos-modifications.gschema.override /tmp/bftos-schema-test/
echo "Running error test for bftos gschema override. Aborting if failed."
glib-compile-schemas --strict /tmp/bftos-schema-test
echo "Compiling gschema to include bftos setting overrides"
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null

# Hide desktop entries
if [[ -f /usr/share/applications/btop.desktop ]]; then
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/btop.desktop
fi

# Enable podman-auto-update timer on boot
sed -i 's@\[Timer\]@\[Timer\]\nOnBootSec=15min@g' /usr/lib/systemd/user/podman-auto-update.timer
