---
name: nix-run
description: >
  CLI ツールが見つからない、または一時的に使いたいときに `nix run` / `nix shell` で実行する方法を案内するスキル。
  `command not found` エラーが出たとき、ユーザーから「〜をインストールして」「〜を使って」と言われたが当該コマンドが PATH にないとき、
  あるいはワンショットで実行できればよいツール（jq, fd, ripgrep, http, gh, fzf など）を使いたい場面で必ず使う。
  apt / brew / npm install -g などのグローバルインストールを提案する前に、まずこのスキルを参照する。
---

# nix-run スキル

CLI ツールが手元になくても、Nix がインストールされていれば `nix run` で即座に実行できる。
インストールを伴わずにツールを試せるため、エージェントのワークフローや一時利用に向く。

## 使う場面

- Bash 実行中に `command not found` が出た
- ユーザーが「〜をインストールして」と言ったが、永続化までは必要なさそう
- ワークフローの中で短時間だけ特定の CLI が必要になった

## 基本パターン

ツールを一度だけ実行したいとき：

```bash
nix run nixpkgs#<package> -- <args>
```

`--` 以降が対象コマンドへの引数になる。例:

```bash
nix run nixpkgs#jq -- '.items[].name' data.json
nix run nixpkgs#ripgrep -- 'TODO' src/
nix run nixpkgs#httpie -- GET https://example.com
```

複数コマンドを連続で使うなら、`nix shell` で一時的な環境を作る：

```bash
nix shell nixpkgs#jq nixpkgs#ripgrep -c bash -c '...'
# あるいは対話的に
nix shell nixpkgs#jq nixpkgs#ripgrep
```

## パッケージ名がわからないとき

`nix search` は重いので、まずは推測する。多くは小文字パッケージ名そのまま (`jq`, `ripgrep`, `fd`, `gh`, `fzf`, `bat`, `eza`, `httpie`)。
推測がうまくいかない場合のみ:

```bash
nix search nixpkgs <keyword>
```

主要コマンドとパッケージ名が一致しないケース:

| コマンド | パッケージ |
|---|---|
| `rg` | `ripgrep` |
| `http`, `https` | `httpie` |
| `cargo`, `rustc` | `rustc` または `cargo` |
| `psql` | `postgresql` |
| `aws` | `awscli2` |

## やらないこと

- `apt install` / `brew install` / `npm install -g` / `pip install --user` などのグローバルインストールを最初の選択肢として提示しない。
  ユーザーの環境が Nix で管理されているため、これらはシステムを汚す。
- 永続化が必要な場合でも、勝手に `home.nix` などを編集しない。ユーザーに「永続化するなら home-manager 側に追加できます」と提案するに留める。

## 失敗したとき

- `error: flake 'nixpkgs' does not provide attribute ...`: パッケージ名が違う。`nix search nixpkgs <keyword>` で探す。
- `experimental feature 'nix-command' / 'flakes'` のエラー: Nix の experimental features が無効。
  `--extra-experimental-features 'nix-command flakes'` を付けるか、`~/.config/nix/nix.conf` に設定済みかを確認する。
- そもそも `nix` コマンド自体がない場合のみ、別の手段（brew など）を検討する。
