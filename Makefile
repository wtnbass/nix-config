UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
switch:
	darwin-rebuild switch --flake .
else
switch:
	sudo nixos-rebuild switch --flake .
endif
