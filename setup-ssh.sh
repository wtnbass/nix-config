#!/usr/bin/env bash
# 新 PC セットアップ用: GitHub 用の SSH 鍵を生成して公開鍵を表示する
set -euo pipefail

SSH_DIR="$HOME/.ssh"
HOSTNAME_LABEL="$(hostname -s)"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

generate_key() {
  local name="$1"
  local comment="$2"
  local path="$SSH_DIR/$name"

  if [[ -e "$path" ]]; then
    echo "skip: $path already exists"
    return
  fi

  ssh-keygen -t ed25519 -f "$path" -C "$comment" -N ""
  chmod 600 "$path"
  chmod 644 "$path.pub"
  echo "created: $path"
}

generate_key "id_github_personal" "github-personal@$HOSTNAME_LABEL"
generate_key "id_github_work"     "github-work@$HOSTNAME_LABEL"

echo
echo "==== 公開鍵 ===="
echo "--- id_github_personal.pub (個人 GitHub アカウントに登録) ---"
cat "$SSH_DIR/id_github_personal.pub"
echo "--- id_github_work.pub (Work GitHub アカウントに登録) ---"
cat "$SSH_DIR/id_github_work.pub"
echo
echo "次の手順:"
echo "  1. id_github_personal.pub / id_github_work.pub を該当 GitHub アカウントに登録"
echo "      Github SSH key page: https://github.com/settings/keys"
echo "  2. make で適用"
echo "  3. 接続確認"
echo "      ssh -T git@github.com"
echo "      ssh -T git@github-work"
