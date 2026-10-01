#!/bin/bash
set -e

# Create a persistent workspace directory to cache the ZMK repository and avoid re-downloading it every time
mkdir -p ~/zmk-workspace

echo "Starting Docker build..."
docker run --rm \
  -v ~/zmk-workspace:/workspace \
  -v "$(pwd)":/workspace/zmk-config \
  -w /workspace \
  zmkfirmware/zmk-dev-arm:3.5 \
  bash -c "
    if [ ! -d '.west' ]; then
      mkdir -p .west
      cat <<EOF > .west/config
[manifest]
path = zmk-config
file = config/west.yml
EOF
    fi &&
    west update &&
    west zephyr-export &&
    echo 'Building firmware (Left Half)...' &&
    west build -s zmk/app -d build/left -b nice_nano_v2 -- -DZMK_CONFIG=/workspace/zmk-config/config '-DSHIELD=lily58_left nice_view_adapter nice_view_custom raw_hid_adapter' -DCONFIG_ZMK_STUDIO=y -DSNIPPET='studio-rpc-usb-uart'
  "
