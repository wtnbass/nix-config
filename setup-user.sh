#!/bin/bash

# Generate user.nix with current username and hostname

USERNAME=$(whoami)
HOSTNAME=$(hostname -s)

cat > user.nix << EOF
{
  username = "${USERNAME}";
  hostname = "${HOSTNAME}";
  home = "${HOME}";
}
EOF
