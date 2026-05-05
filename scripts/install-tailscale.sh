#!/bin/bash

# Installs Tailscale on an Ubuntu server.
# Authentication, SSH enablement, and device tagging are completed after install.

set -e

echo "Installing Tailscale..."

curl -fsSL https://tailscale.com/install.sh | sh

echo
echo "Tailscale installed successfully."
echo
echo "Next steps:"
echo
echo "1. Join this server to your tailnet using your reusable auth key:"
echo "   sudo tailscale up --auth-key <YOUR_AUTH_KEY>"
echo
echo "2. Enable Tailscale SSH:"
echo "   sudo tailscale up --ssh"
echo
echo "3. Apply the correct device tag in the Tailscale Admin Console:"
echo "   adminserver -> tag:admin"
echo "   parents     -> tag:parents-backup"
echo "   inlaws      -> tag:inlaws-backup"
echo
echo "4. Verify connectivity:"
echo "   tailscale status"
