#!/bin/bash

set -e

echo "Installing Tailscale..."

curl -fsSL https://tailscale.com/install.sh | sh

echo "Tailscale installed."
echo
echo "Next steps:"
echo "1. Join this server to your tailnet:"
echo "   sudo tailscale up --auth-key <YOUR_AUTH_KEY>"
echo
echo "2. Enable Tailscale SSH:"
echo "   sudo tailscale up --ssh"
echo
echo "3. Apply the correct device tag in the Tailscale Admin Console."
echo
echo "Example tags:"
echo "   adminserver -> tag:admin"
echo "   parents     -> tag:parents-backup"
echo "   inlaws      -> tag:inlaws-backup"
