#!/bin/bash

# Get all sinks with their IDs and names
DAC_INFO=$(wpctl status | grep "PCM2704.*Analog Stereo" | head -1)
CODEC_INFO=$(wpctl status | grep "PCM2902.*Analog Stereo" | head -1)

# Extract IDs (remove dot and asterisk)
DAC_ID=$(echo "$DAC_INFO" | awk '{print $2}' | tr -d '.*')
CODEC_ID=$(echo "$CODEC_INFO" | awk '{print $2}' | tr -d '.*')

# Get current default by checking which has the asterisk
if echo "$DAC_INFO" | grep -q '\*'; then
    # DAC is current, switch to CODEC
    wpctl set-default $CODEC_ID
    TARGET_NAME="alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output"
    notify-send "Audio Output" "Switched to USB Audio CODEC (Headphones)" -i audio-headphones
else
    # CODEC is current (or neither), switch to DAC
    wpctl set-default $DAC_ID
    TARGET_NAME="alsa_output.usb-Burr-Brown_from_TI_USB_Audio_DAC-00.analog-stereo"
    notify-send "Audio Output" "Switched to USB Audio DAC (Speakers)" -i audio-speakers
fi

# Move all playing streams to the new device
pactl list short sink-inputs 2>/dev/null | while read stream; do
    stream_id=$(echo $stream | cut -f1)
    pactl move-sink-input $stream_id "$TARGET_NAME" 2>/dev/null
done