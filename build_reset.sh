#!/bin/bash
set -e
docker run --rm \
  -v ~/zmk-workspace:/workspace \
  -v "$(pwd)":/workspace/zmk-config \
  -w /workspace \
  zmkfirmware/zmk-dev-arm:3.5 \
  bash -c "
    west zephyr-export &&
    west build -s zmk/app -d build/reset -b nice_nano_v2 -- -DSHIELD=settings_reset &&
    cp build/reset/zephyr/zmk.uf2 /workspace/zmk-config/settings_reset.uf2
  "
