#!/bin/bash

echo "Starting printer server setup..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install CUPS and drivers
sudo apt install -y cups printer-driver-brlaser printer-driver-gutenprint wget

# Enable and start CUPS
sudo systemctl enable cups
sudo systemctl start cups

# Allow CUPS access from LAN
sudo cupsctl --remote-any
sudo systemctl restart cups

echo "CUPS installed and running."

# Add Brother printer
lpadmin -p Brother_MFC -E -v ipp://192.168.1.76/ipp/print -m everywhere

# Add Canon printer
lpadmin -p Canon_MF247dw -E -v ipp://192.168.1.77/ipp/print -m everywhere

echo "Brother and Canon printers added to CUPS."

# Install Mobility Print
echo "Downloading Mobility Print..."
wget https://cdn.papercut.com/files/mobility-print/mobility-print-printer-sharing_1.0.1236_amd64.deb

sudo dpkg -i mobility-print-printer-sharing_1.0.1236_amd64.deb

echo "Mobility Print installed."

# Open firewall ports if needed
if sudo ufw status | grep -q active; then
  echo "UFW firewall is active, opening required ports..."
  sudo ufw allow 9163/tcp
  sudo ufw allow 631/tcp
  sudo ufw reload
fi

# Completion message
echo "Setup complete!"
echo "Access Mobility Print Admin Panel at: http://localhost:9163/admin"
echo "All users can now print via Mobility Print from Windows, ChromeOS, and Linux."
