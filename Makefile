PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin

.PHONY: install uninstall test

install:
	install -d "$(DESTDIR)$(BINDIR)"
	install -m 755 bin/termrec "$(DESTDIR)$(BINDIR)/termrec"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/termrec"

test:
	bash -n bin/termrec install.sh tests/smoke.sh
	bash tests/smoke.sh
