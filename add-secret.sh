#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SECRETS_DIR="$REPO_ROOT/secrets"
SECRETS_NIX="$REPO_ROOT/secrets.nix"
SSH_KEY="/etc/ssh/ssh_host_ed25519_key"

# Usage
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <secret-name>"
  echo "Example: $0 my-app-password"
  exit 1
fi

SECRET_NAME="$1"
SECRET_FILE="secrets/${SECRET_NAME}.age"
SECRET_PATH="$SECRETS_DIR/${SECRET_NAME}.age"

# Check secrets.nix exists
if [[ ! -f "$SECRETS_NIX" ]]; then
  echo "❌ secrets.nix not found at $SECRETS_NIX"
  exit 1
fi

# Check if secret already exists
if [[ -f "$SECRET_PATH" ]]; then
  echo "⚠️  Secret '$SECRET_NAME' already exists at $SECRET_PATH"
  read -rp "Edit it anyway? [y/N] " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] || exit 0
fi

# Check if secret is already declared in secrets.nix
if grep -q "\"${SECRET_FILE}\"" "$SECRETS_NIX"; then
  echo "✅ Already declared in secrets.nix"
else
  echo "📝 Adding '$SECRET_FILE' to secrets.nix..."
  # Insert before the closing brace
  # Find the last line with .publicKeys and add after it
  SERVER_KEY=$(grep -oP '(?<=publicKeys = \[ ).*(?= \];)' "$SECRETS_NIX" | head -1)
  
  # Use sed to insert before the closing `}`
  sed -i "s|^}$|  \"${SECRET_FILE}\".publicKeys = [ ${SERVER_KEY} ];\n}|" "$SECRETS_NIX"
  echo "✅ Added to secrets.nix"
fi

# Create the secrets directory if it doesn't exist
mkdir -p "$SECRETS_DIR"

# Create/edit the secret with agenix
echo "🔐 Opening editor for secret '$SECRET_NAME'..."
nix run github:ryantm/agenix -- -e "$SECRET_FILE" -i "$SSH_KEY"

echo ""
echo "✅ Secret '$SECRET_NAME' created at $SECRET_PATH"
echo ""
echo "Next steps:"
echo "  1. Add to your NixOS config:"
echo ""
echo "     age.secrets.${SECRET_NAME} = {"
echo "       file = ./secrets/${SECRET_NAME}.age;"
echo "       path = \"/run/agenix/${SECRET_NAME}\";"
echo "       owner = \"root\";"
echo "       mode = \"0444\";"
echo "     };"
echo ""
echo "  2. Commit and push:"
echo "     git add secrets/${SECRET_NAME}.age secrets.nix"
echo "     git commit -m \"add ${SECRET_NAME} secret\""
