#!/bin/bash

# Optimal display settings for Samsung LU28R55 28" 4K monitor

echo "Applying optimal display settings for Samsung LU28R55..."

# Set monitor to native 4K@60Hz with 1.5x scale (best for 28" 4K)
hyprctl keyword monitor HDMI-A-1,3840x2160@60,0x0,1.5

# Color and rendering optimizations
hyprctl keyword decoration:screen_shader ~/.config/hypr/shaders/vibrance.glsl 2>/dev/null || true

# Set proper DPI for GTK/Qt apps
hyprctl keyword env GDK_SCALE,1.5
hyprctl keyword env QT_SCALE_FACTOR,1.5
hyprctl keyword env QT_FONT_DPI,144

# Font rendering optimizations for sharper text
hyprctl keyword env FREETYPE_PROPERTIES,"cff:no-stem-darkening=0 autofitter:warping=1"

# Ensure XWayland apps scale properly
hyprctl keyword xwayland:force_zero_scaling true

echo "✓ Display optimized for best clarity and comfort"
notify-send "Display Optimized" "Samsung LU28R55 configured for best viewing experience" -t 3000