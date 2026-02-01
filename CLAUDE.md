# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Apply configuration changes (auto-detects Darwin/NixOS)
make
```

- macOS: `darwin-rebuild switch --flake .`
- NixOS/WSL: `sudo nixos-rebuild switch --flake .`

## Architecture

This is a Nix flake-based configuration for NixOS-WSL with Home Manager.

### File Structure

- `flake.nix` - Flake entry point. Defines inputs (nixpkgs, home-manager, nixos-wsl, nix-ld) and the nixosConfiguration for host `nixos`
- `configuration.nix` - NixOS system-level configuration (system packages, WSL settings)
- `home.nix` - Home Manager user configuration (user packages, shell config, program settings)

### Key Design Decisions

- Uses `nixpkgs-unstable` channel
- Home Manager is integrated as a NixOS module (not standalone)
- `nix-ld` is enabled for running unpatched dynamically linked binaries
- Unfree packages are allowed selectively via `allowUnfreePredicate`
