# !/bin/bash

# Define variables
DESKTOP_FILE="/usr/share/wayland-sessions/sway.desktop"
CUSTOM_SCRIPT="/usr/local/bin/custom-sway-session"

# Check if the Sway desktop file exists
if [ ! -f "$DESKTOP_FILE" ]; then
	echo "Error: Sway desktop file not found at $DESKTOP_FILE"
	exit 1
fi

# Backup the existing desktop file
sudo cp "$DESKTOP_FILE" "${DESKTOP_FILE}.bak"
if [ $? -ne 0 ]; then
	echo "Error: Failed to backup $DESKTOP_FILE"
	exit 1
fi
echo "Backup of $DESKTOP_FILE created at ${DESKTOP_FILE}.bak"

# Update the desktop file to point to the custom script
sudo sed -i "s|^Exec=.*|Exec=$CUSTOM_SCRIPT|" "$DESKTOP_FILE"
if [ $? -ne 0 ]; then
	echo "Error: Failed to update $DESKTOP_FILE"
	exit 1
fi
echo "Updated $DESKTOP_FILE to use $CUSTOM_SCRIPT"

# Create the custom script
sudo tee "$CUSTOM_SCRIPT" >/dev/null <<'EOF'
#!/bin/bash

# Your custom commands here
echo "Running custom pre-Sway commands"

# Set environment variables
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

# Call the original sway executable
exec sway
EOF
if [ $? -ne 0 ]; then
	echo "Error: Failed to create $CUSTOM_SCRIPT"
	exit 1
fi

sudo chmod +x "$CUSTOM_SCRIPT"
if [ $? -ne 0 ]; then
	echo "Error: Failed to make $CUSTOM_SCRIPT executable"
	exit 1
fi
echo "Custom script created at $CUSTOM_SCRIPT and made executable"

echo "Setup complete. You can now select the Sway session from GDM and it will run the custom script before starting Sway."
exit 0
