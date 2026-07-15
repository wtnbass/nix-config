UNAME := $(shell uname)
CLEAN_KEEP_GENERATIONS ?= 3

.PHONY: switch update clean setup-ssh-keys

.DEFAULT_GOAL := switch

ifeq ($(UNAME), Darwin)
switch:
	sudo darwin-rebuild switch --flake .
else
switch:
	sudo nixos-rebuild switch --flake .
endif

update:
	nix flake update --flake ./home/agents/skills
	nix flake update

clean:
	CLEAN_KEEP_GENERATIONS=$(CLEAN_KEEP_GENERATIONS) ./scripts/clean-nix-store.sh

# 新 PC で実行: SSH 鍵 (id_ed25519, id_github_personal, id_github_work) を生成
setup-ssh-keys:
	./setup-ssh.sh
