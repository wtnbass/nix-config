# nix-config

このリポジトリの nix-config に関する操作を支援するスキルです。

## リポジトリ構成

- `flake.nix` — flake 定義。inputs/outputs を管理
- `hosts/wsl/` — NixOS-WSL 向け設定
- `hosts/macos/` — nix-darwin (macOS) 向け設定
- `home/` — home-manager モジュール群
- `pkgs/` — カスタムパッケージ定義
- `skills/` — エージェントスキル定義

## よく使うコマンド

```bash
# WSL: システム再ビルド
sudo nixos-rebuild switch --flake .#nixos

# macOS: システム再ビルド
darwin-rebuild switch --flake .#k-watanabe

# flake inputs を更新
nix flake update

# 特定 input だけ更新
nix flake update <input-name>

# ビルド確認 (適用なし)
sudo nixos-rebuild dry-activate --flake .#nixos
```

## 設計方針

- `nixpkgs-unstable` チャンネルを使用
- home-manager は NixOS/darwin モジュールとして統合 (standalone ではない)
- WSL では window ホスト側で管理するツール (vscode, docker など) は home.nix に記載しない
- Unfree パッケージは `allowUnfreePredicate` で個別許可
