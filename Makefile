UNAME := $(shell uname)

.PHONY: switch update clean

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
