#!/bin/bash

# Network Printer Setup Script (Brother MFC & Canon MF247dw)

echo "----------------------------------------"
echo "Network Printer Setup"
echo "Choose which printer(s) to install:"
echo "1. Brother MFC-L98 10C0N"
echo "2. Canon imageCLASS MF247dw"
echo "3. Both"
echo "----------------------------------------"
read -rp "Enter your choice (1/2/3): " CHOICE

# Define IP addresses (replace if different)
BROTHER_IP="192.168.1.76"
CANON_IP="192.168.1.77"

# Ensure CUPS and necessary drivers are installed
echo "Installing CUPS and required printer drivers..."
sudo apt update
sudo apt install -y cups printer-driver-gutenprint printer-driver-brlaser

# Enable and start CUPS service
sudo systemctl enable cups
sudo systemctl start cups

# Function to add Brother printer
install_brother() {
    echo "Adding Brother MFC-L98 10C0N printer..."
    lpadmin -p Brother_MFC_L9810C0N \
        -E \
        -v "ipp://$BROTHER_IP/ipp/print" \
        -m everywhere
    echo "✔ Brother printer added."
}

# Function to add Canon printer
install_canon() {
    echo "Adding Canon imageCLASS MF247dw printer..."
    lpadmin -p Canon_MF247dw \
        -E \
        -v "ipp://$CANON_IP/ipp/print" \
        -m everywhere
    echo "✔ Canon printer added."
}

# Handle user choice
case $CHOICE in
    1)
        install_brother
        ;;
    2)
        install_canon
        ;;
    3)
        install_brother
        install_canon
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose 1, 2, or 3."
        exit 1
        ;;
esac

# Show installed printers
echo "----------------------------------------"
echo "Installed Printers:"
lpstat -p -d
