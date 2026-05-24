# helix の formatter から呼ばれるフォーマッタ・ディスパッチャ。
# 編集中ファイルが属するプロジェクトが biome / prettier / oxfmt の
# どれを使っているかを設定ファイルから自動判定し、stdin の内容を整形して
# stdout に出す。どれにも該当しなければ素通し(cat)する。
#
# 使い方:  hx-fmt-dispatch <buffer_name>   (stdin=原文, stdout=整形結果)
# shebang と set -euo pipefail は writeShellApplication 側が付与する。

file="${1:-}"
if [ -z "$file" ]; then
  cat
  exit 0
fi

# helix が渡す %{buffer_name} は相対パスのことがあるので絶対化する。
case "$file" in
  /*) abs="$file" ;;
  *) abs="$PWD/$file" ;;
esac
dir=$(dirname "$abs")
base=$(basename "$file")
ext="${base##*.}"

# 各フォーマッタが拡張子を扱えるか。biome は対応範囲が限定的なので明示し、
# prettier / oxfmt は markdown / yaml / html 等まで広くカバーするものとして許可する。
supports() {
  case "$1" in
    biome)
      case "$ext" in
        js | cjs | mjs | jsx | ts | cts | mts | tsx | json | jsonc | css | graphql | gql | vue | svelte | astro) return 0 ;;
        *) return 1 ;;
      esac
      ;;
    prettier | oxfmt) return 0 ;;
    *) return 1 ;;
  esac
}

# 実行バイナリを解決する: ファイルに最も近い node_modules/.bin を優先し、
# 無ければ PATH(= runtimeInputs で注入した Nix 版)にフォールバックする。
resolve() {
  local name="$1"
  local d="$dir"
  while true; do
    if [ -x "$d/node_modules/.bin/$name" ]; then
      printf '%s\n' "$d/node_modules/.bin/$name"
      return 0
    fi
    if [ "$d" = / ]; then
      break
    fi
    d=$(dirname "$d")
  done
  local p
  if p=$(command -v "$name" 2>/dev/null); then
    printf '%s\n' "$p"
    return 0
  fi
  return 1
}

# ディレクトリ $1 にフォーマッタ $2 の設定があるか。
has_cfg() {
  local d="$1"
  local fmt="$2"
  case "$fmt" in
    biome)
      if [ -e "$d/biome.json" ] || [ -e "$d/biome.jsonc" ]; then
        return 0
      fi
      return 1
      ;;
    prettier)
      local f
      for f in .prettierrc .prettierrc.json .prettierrc.yaml .prettierrc.yml \
        .prettierrc.json5 .prettierrc.jsonc .prettierrc.toml \
        .prettierrc.js .prettierrc.cjs .prettierrc.mjs \
        .prettierrc.ts .prettierrc.cts .prettierrc.mts \
        prettier.config.js prettier.config.cjs prettier.config.mjs \
        prettier.config.ts prettier.config.cts prettier.config.mts; do
        if [ -e "$d/$f" ]; then
          return 0
        fi
      done
      # package.json トップレベルの "prettier" キー (依存名との誤検出を避けるため jq で見る)
      if [ -e "$d/package.json" ] && jq -e 'has("prettier")' "$d/package.json" >/dev/null 2>&1; then
        return 0
      fi
      return 1
      ;;
    oxfmt)
      local g
      for g in .oxfmtrc.json .oxfmtrc.jsonc .oxfmtrc.ts .oxfmtrc.mts .oxfmtrc.cts \
        .oxfmtrc.js .oxfmtrc.mjs .oxfmtrc.cjs; do
        if [ -e "$d/$g" ]; then
          return 0
        fi
      done
      return 1
      ;;
    *)
      return 1
      ;;
  esac
}

# ファイルのディレクトリから上方向に探索し、最初に見つかった設定 = 最も近い設定を
# 採用する。同一階層に複数あれば biome > prettier > oxfmt の順で選ぶ。
# 拡張子を扱えないフォーマッタはスキップして探索を続ける。
chosen=""
chosen_bin=""
d="$dir"
while true; do
  for fmt in biome prettier oxfmt; do
    if has_cfg "$d" "$fmt" && supports "$fmt"; then
      if bin=$(resolve "$fmt"); then
        chosen="$fmt"
        chosen_bin="$bin"
        break
      fi
    fi
  done
  if [ -n "$chosen" ]; then
    break
  fi
  if [ "$d" = / ]; then
    break
  fi
  d=$(dirname "$d")
done

# 該当フォーマッタが無ければ原文をそのまま返す (helix 側は変更なしとみなす)。
if [ -z "$chosen" ]; then
  cat
  exit 0
fi

case "$chosen" in
  biome) exec "$chosen_bin" format --stdin-file-path="$file" ;;
  prettier) exec "$chosen_bin" --stdin-filepath "$file" ;;
  oxfmt) exec "$chosen_bin" --stdin-filepath="$file" ;;
esac
