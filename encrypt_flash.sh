1#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root (use sudo)."
    exit 1
fi

# Display available block devices
echo "Available drives:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

# Prompt user to select a device
read -p "Enter the device name to encrypt (e.g., sdb): " DEVICE

# Confirm the user's choice
echo "You selected /dev/$DEVICE. All data will be erased."
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Set up encryption
echo "Setting up encryption for /dev/$DEVICE..."
cryptsetup luksFormat /dev/$DEVICE

# Open encrypted device
cryptsetup open /dev/$DEVICE encrypted_flash

# Create a file system
mkfs.ext4 /dev/mapper/encrypted_flash

echo "Encryption complete. You can mount the device as needed."

# Close the encrypted device (optional step)
cryptsetup close encrypted_flash

