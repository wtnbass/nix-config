# nix-config

NixOS-WSL + macOS (nix-darwin) の dotfiles。

## 適用

```bash
make
```

- NixOS/WSL: `sudo nixos-rebuild switch --flake .`
- macOS: `sudo darwin-rebuild switch --flake .`

## 構成

```
flake.nix          # エントリ。hosts/*/home.nix のみを import
hosts/
  macos/           # nix-darwin 用 (configuration.nix / home.nix)
  wsl/             # NixOS-WSL 用 (configuration.nix / home.nix)
home/              # home-manager モジュール。各 host が必要なものを import
  claude/          # claude-code + statusline
  ghostty/         # ghostty 設定 (現状 macOS のみで import)
  langs/           # 言語別。default.nix は普段使う言語だけ集約
  fish.nix git.nix helix.nix ssh.nix tmux.nix tools.nix
pkgs/              # カスタムパッケージ。flake.nix の overlay で公開
setup-ssh.sh       # 新マシン用の SSH 鍵生成スクリプト
```

### 言語環境の追加

`home/langs/<lang>.nix` を作成し、常用するなら `home/langs/default.nix` の `imports` に追加する。
go / rust / zig / haskell は実装済みだが default に入れていないので、必要になったら import する。

## 新 PC セットアップ

```bash
# 1. GitHub 用の SSH 鍵を生成
make setup-ssh-keys

# 2. 表示された公開鍵を該当 GitHub アカウントに登録
#    - id_github_personal.pub → 個人アカウント
#    - id_github_work.pub     → Work アカウント

# 3. 設定を適用
make
```

`home/ssh.nix` の `matchBlocks` で `github.com` / `github-work` ホストに identityFile を割り当てており、`home/git.nix` の url 書き換えと連携して個人/Work リポジトリを自動で振り分ける。
