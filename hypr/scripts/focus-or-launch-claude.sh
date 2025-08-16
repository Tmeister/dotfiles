#!/bin/bash

# Try to focus existing Claude window
result=$(hyprctl dispatch focuswindow 'title:.*Claude.*Zen Browser' 2>&1)

if [[ "$result" == "ok" ]]; then
    # Window found and focused
    exit 0
else
    # Launch new window if not found
    MOZ_ENABLE_WAYLAND=1 uwsm app -- zen-browser --new-window https://claude.ai
fi