.PHONY: test

test:
	grep -l '^#!/usr/bin/env .*sh' .bin/* bootstrap/install-* bootstrap/update-* bootstrap/clean bootstrap/dotfiles-* | xargs shellcheck --color
