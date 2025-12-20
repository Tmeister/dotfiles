#!/bin/bash

# Resolution toggle script for dual monitor setup
# Cycles through scales: 1.5 -> 1.666667 -> 2.0 -> 1.5

# Get current scale of DP-1 specifically
CURRENT_SCALE=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-1") | .scale')

case "$CURRENT_SCALE" in
    1.5*)
        NEXT_SCALE=1.666667
        GDK_VALUE=1.5
        HDMI_Y=1296
        ;;
    1.6*)
        NEXT_SCALE=2.0
        GDK_VALUE=2
        HDMI_Y=1080
        ;;
    2*)
        NEXT_SCALE=1.5
        GDK_VALUE=1.5
        HDMI_Y=1440
        ;;
    *)
        NEXT_SCALE=1.5
        GDK_VALUE=1.5
        HDMI_Y=1440
        ;;
esac

# Disable HDMI first to prevent overlap warning
hyprctl keyword monitor HDMI-A-1,disable

# Apply new scale to primary monitor
hyprctl keyword monitor DP-1,3840x2160@60,0x0,$NEXT_SCALE

# Brief pause for Hyprland to process the scale change
sleep 0.1

# Re-enable HDMI at the correct position (1600x900 for larger text on 13" display)
hyprctl keyword monitor HDMI-A-1,1600x900@60,0x${HDMI_Y},1.0

# Update GDK scale
hyprctl keyword env GDK_SCALE,$GDK_VALUE

notify-send "Display Scaling" "Changed to ${NEXT_SCALE}x" -t 2000