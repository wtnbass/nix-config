UNAME := $(shell uname)

.PHONY: switch pre-switch post-switch clean

.DEFAULT_GOAL := switch

pre-switch:
	@./setup-user.sh
	@git add user.nix

post-switch:
	@-git rm -f --cached user.nix 2>/dev/null || true
	@rm -f user.nix

clean: post-switch

ifeq ($(UNAME), Darwin)
switch: pre-switch
	@trap 'git rm -f --cached user.nix 2>/dev/null; rm -f user.nix' EXIT; \
	sudo darwin-rebuild switch --flake .
else
switch:
	sudo nixos-rebuild switch --flake .
endif
