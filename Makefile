UNAME := $(shell uname)

.PHONY: switch pre-switch post-switch clean

.DEFAULT_GOAL := switch

user.nix:
	@./setup-user.sh
	@git add user.nix

ifeq ($(UNAME), Darwin)
switch: user.nix
	@trap 'git rm -f --cached user.nix 2>/dev/null; rm -f user.nix' EXIT; \
	sudo darwin-rebuild switch --flake .
else
switch: user.nix
	@trap 'git rm -f --cached user.nix 2>/dev/null; rm -f user.nix' EXIT; \
	sudo nixos-rebuild switch --flake .
endif
