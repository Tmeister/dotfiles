#!/bin/bash

MON=$(hyprctl monitors -j | jq -r ".[0].name")
CURRENT_SCALE=$(hyprctl monitors -j | jq -r ".[0].scale")

case "$CURRENT_SCALE" in
    1.25*)
        NEXT_SCALE=1.5
        GDK_VALUE=1.5
        ;;
    1.5*)
        NEXT_SCALE=2.0
        GDK_VALUE=2
        ;;
    2*)
        NEXT_SCALE=1.25
        GDK_VALUE=1.25
        ;;
    *)
        NEXT_SCALE=1.5
        GDK_VALUE=1.5
        ;;
esac

hyprctl keyword monitor "$MON",3840x2160@60,0x0,"$NEXT_SCALE"
hyprctl keyword env GDK_SCALE,$GDK_VALUE

notify-send "Display Scaling" "Changed to ${NEXT_SCALE}x" -t 2000