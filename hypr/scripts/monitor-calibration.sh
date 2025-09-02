#!/bin/bash

# Monitor calibration helper for Samsung LU28R55
# Run this to test different viewing modes

echo "Samsung LU28R55 Monitor Calibration Tool"
echo "========================================="
echo ""
echo "Select viewing preference:"
echo "1) Productivity (Current - 1.5x scale, 2560x1440 workspace)"
echo "2) More Space (1.25x scale, 3072x1728 workspace)"
echo "3) Larger Text (1.75x scale, 2194x1234 workspace)"
echo "4) Maximum Clarity (2.0x scale, 1920x1080 workspace)"
echo "5) Native/Gaming (1.0x scale, 3840x2160 - tiny UI!)"
echo ""
read -p "Choice [1-5]: " choice

MON="HDMI-A-1"

case $choice in
    1)
        SCALE=1.5
        GDK=1.5
        DPI=144
        DESC="Productivity Mode"
        ;;
    2)
        SCALE=1.25
        GDK=1.25
        DPI=120
        DESC="More Space Mode"
        ;;
    3)
        SCALE=1.75
        GDK=1.75
        DPI=168
        DESC="Larger Text Mode"
        ;;
    4)
        SCALE=2.0
        GDK=2
        DPI=192
        DESC="Maximum Clarity Mode"
        ;;
    5)
        SCALE=1.0
        GDK=1
        DPI=96
        DESC="Native Resolution Mode"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo "Applying $DESC..."
hyprctl keyword monitor "$MON",3840x2160@60,0x0,"$SCALE"
hyprctl keyword env GDK_SCALE,$GDK
hyprctl keyword env QT_SCALE_FACTOR,$GDK
hyprctl keyword env QT_FONT_DPI,$DPI

notify-send "Monitor Mode" "$DESC applied (Scale: ${SCALE}x)" -t 3000
echo "✓ $DESC applied successfully!"
echo ""
echo "If you like this setting, update ~/.config/hypr/monitors.conf"