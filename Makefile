UNAME := $(shell uname)
SWITCH_ULIMIT ?= 65535

.PHONY: switch update clean setup-ssh-keys

.DEFAULT_GOAL := switch

ifeq ($(UNAME), Darwin)
switch:
	ulimit -n $(SWITCH_ULIMIT) && sudo darwin-rebuild switch --flake .
else
switch:
	ulimit -n $(SWITCH_ULIMIT) && sudo nixos-rebuild switch --flake .
endif

update:
	nix flake update

clean:
	nix-collect-garbage

# 新 PC で実行: SSH 鍵 (id_ed25519, id_github_personal, id_github_work) を生成
setup-ssh-keys:
	./setup-ssh.sh
