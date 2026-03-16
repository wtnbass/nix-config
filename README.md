# nix-config

NixOS-WSL + macOS (nix-darwin) configuration.

## Apply configuration

```bash
make
```

- NixOS/WSL: `sudo nixos-rebuild switch --flake .`
- macOS: `darwin-rebuild switch --flake .`

## DevShell templates

Go や Rust などの言語環境はプロジェクトごとに devShell で管理する。

### 使い方

```bash
# プロジェクトディレクトリで初期化
mkdir my-project && cd my-project
nix flake init -t /path/to/nix-config#go   # または #rust

# direnv を許可（初回のみ）
direnv allow
```

以降は `cd` するだけで自動的に環境が有効になる。

### 利用可能なテンプレート

| テンプレート | 内容 |
|---|---|
| `#go` | go, gopls, golangci-lint, delve |
| `#rust` | cargo, rustc, clippy, rustfmt, rust-analyzer (stable) |

### nightly / beta に変更する場合

`flake.nix` の該当行を変更する。

```nix
# stable → nightly
fenix.packages.${system}.complete.toolchain
fenix.packages.${system}.complete.rust-analyzer
```

### テンプレート一覧確認

```bash
nix flake show /path/to/nix-config
```
