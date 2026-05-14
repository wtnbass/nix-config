# nix-config

このリポジトリは nix を利用して設定した dotfiles です。
Nix-WSL と MacOS が設定の対象で他のPCでも同様の環境が即座に揃うことを目的としています。
flake をベースに構成され、ほとんどの設定は home-manager で行い、システム向けの最低限の設定を configuration.nix で行っています。

### Key Design Decisions

- Uses `nixpkgs-unstable` channel
- Home Manager is integrated as a NixOS module (not standalone)
- `nix-ld` is enabled for running unpatched dynamically linked binaries
- Unfree packages are allowed selectively via `allowUnfreePredicate`

## MacOS

基本的には nixpkgs を使用する。
安定性などmacos依存が強いパッケージは homebrew を利用する。

## WSL

nix-ld を使う。 window ホストで存在していて欲しいパッケージ (vscode, zed, docker など) は home.nix に記載しない。

## Tasks

定期的に実行するコマンドは make を使用する。
switch や update, clean などが該当する。

@Makefile

