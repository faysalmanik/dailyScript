#!/bin/bash

# Network Printer Setup Script (Brother, Canon, Epson)

echo "----------------------------------------"
echo "Network Printer Setup"
echo "Choose which printer(s) to install:"
echo "1. Brother MFC-L98 10C0N"
echo "2. Canon imageCLASS MF247dw"
echo "3. Epson M3170"
echo "4. All"
echo "----------------------------------------"
read -rp "Enter your choice (1/2/3/4): " CHOICE

# Define IP addresses
BROTHER_IP="192.168.1.76"
CANON_IP="192.168.1.77"
EPSON_IP="192.168.1.31"

# Ensure CUPS and drivers are installed
echo "Installing CUPS and printer drivers..."
sudo apt update
sudo apt install -y cups printer-driver-gutenprint printer-driver-brlaser printer-driver-escpr

# Enable and start CUPS
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

# Function to add Epson printer
install_epson() {
    echo "Adding Epson M3170 printer..."
    lpadmin -p Epson_M3170 \
        -E \
        -v "ipp://$EPSON_IP/ipp/print" \
        -m everywhere
    echo "✔ Epson printer added."
}

# Handle user selection
case $CHOICE in
    1)
        install_brother
        ;;
    2)
        install_canon
        ;;
    3)
        install_epson
        ;;
    4)
        install_brother
        install_canon
        install_epson
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose 1 to 4."
        exit 1
        ;;
esac

# Show installed printers
echo "----------------------------------------"
echo "Installed Printers:"
lpstat -p -d
