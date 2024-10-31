#!/usr/bin/bash

set -eoux pipefail

echo "Running image-info branding changes"

image_name="bftos"
image_flavor="main"
image_vendor="befanyt"
image_ref="ostree-image-signed:docker://ghcr.io/befanyt/bftos"
base_image="silverblue"

# Branding
cat <<<"$(jq ".\"image-name\" |= \"${image_name}\" |
              .\"image-flavor\" |= \"${image_flavor}\" |
              .\"image-vendor\" |= \"${image_vendor}\" |
              .\"image-ref\" |= \"${image_ref}\" |
              .\"image-tag\" |= \"${IMAGE}\" |
              .\"base-image-name\" |= \"${base_image}\" |
              .\"fedora-version\" |= \"$(rpm -E %fedora)\"" \
    </usr/share/ublue-os/image-info.json)" \
>/tmp/image-info.json
cp /tmp/image-info.json /usr/share/ublue-os/image-info.json

