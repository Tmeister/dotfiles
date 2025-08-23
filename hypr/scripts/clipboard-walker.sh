#!/bin/bash
# Clipboard manager using cliphist backend with walker UI

# Get clipboard history, extract just the content (remove ID), and show in walker
selected=$(cliphist list | sed 's/^[0-9]*\t//' | walker --dmenu)

# If something was selected, find it in the full list and decode it
if [ -n "$selected" ]; then
    # Find the line with this content and get its full entry with ID
    full_entry=$(cliphist list | grep -F "$selected" | head -1)
    # Decode and copy to clipboard
    echo "$full_entry" | cliphist decode | wl-copy
    
    # Simple and reliable: just copy to clipboard
    # Auto-paste is unreliable in browsers due to Wayland security restrictions
    notify-send "Clipboard" "📋 Copied to clipboard" -t 1500
fi