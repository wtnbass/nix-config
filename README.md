# nix-config

NixOS-WSL + macOS (nix-darwin) configuration.

## Apply configuration

```bash
make
```

- NixOS/WSL: `sudo nixos-rebuild switch --flake .`
- macOS: `darwin-rebuild switch --flake .`

## 新 PC セットアップ

SSH 鍵はマシンごとに生成し、公開鍵を GitHub に登録する。秘密鍵はリポジトリに含めない。

```bash
# 1. GitHub 用の SSH 鍵を生成（id_github_personal / id_github_work）
make setup-ssh-keys

# 2. 表示された公開鍵を該当 GitHub アカウントに登録
#    - id_github_personal.pub → 個人アカウント
#    - id_github_work.pub     → Work アカウント

# 3. 設定を適用
make
```

`programs.ssh.matchBlocks` で `github.com` / `github-work` ホストに対する identityFile が定義されているので、上記 2 本のファイル名のまま生成すれば git url リライト (`url."git@github-work:EARTHBRAIN/".insteadOf`) がそのまま機能する。
