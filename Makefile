.PHONY: test

test:
	grep -l '^#!/usr/bin/env *sh' .bin/* bootstrap/{install,update}-* bootstrap/clean bootstrap/dotfiles-* | xargs shellcheck --color
