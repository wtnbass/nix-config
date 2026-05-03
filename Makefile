UNAME := $(shell uname)

KEY := $(HOME)/.ssh/id_ed25519
KEY_AGE := secrets/bootstrap_id_ed25519.age

.PHONY: switch update clean encrypt-key restore-key

.DEFAULT_GOAL := switch

ifeq ($(UNAME), Darwin)
switch:
	sudo darwin-rebuild switch --flake .
else
switch:
	sudo nixos-rebuild switch --flake .
endif

update:
	nix flake update

clean:
	nix-collect-garbage

# 旧 PC で実行: 既存の SSH 鍵を age パスフレーズで暗号化してリポジトリに保存
encrypt-key:
	nix run nixpkgs#age -- -p -o $(KEY_AGE) $(KEY)

# 新 PC で実行: リポジトリ内の暗号鍵を復号して ~/.ssh/id_ed25519 に展開
restore-key:
	@test ! -e $(KEY) || (echo "$(KEY) already exists"; exit 1)
	mkdir -p $(HOME)/.ssh
	nix run nixpkgs#age -- -d -o $(KEY) $(KEY_AGE)
	chmod 600 $(KEY)
