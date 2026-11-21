PREFIX ?= $(HOME)/.local
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share/dux-icons

.PHONY: install link uninstall test lint

# DMS runs the `dux-icons` command when it is on PATH.
install:
	install -d $(DESTDIR)$(BINDIR) $(DESTDIR)$(DATADIR)/scripts
	install -m 755 scripts/build.py $(DESTDIR)$(DATADIR)/scripts/build.py
	install -m 644 index.theme.in $(DESTDIR)$(DATADIR)/index.theme.in
	rm -rf $(DESTDIR)$(DATADIR)/src
	cp -R src $(DESTDIR)$(DATADIR)/src
	ln -sfnr $(DATADIR)/scripts/build.py $(DESTDIR)$(BINDIR)/dux-icons

link:
	install -d $(BINDIR)
	ln -sfnr $(CURDIR)/scripts/build.py $(BINDIR)/dux-icons

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/dux-icons
	rm -rf $(DESTDIR)$(DATADIR)/src $(DESTDIR)$(DATADIR)/scripts
	rm -f $(DESTDIR)$(DATADIR)/index.theme.in
	-rmdir $(DESTDIR)$(DATADIR)

test:
	python3 -m unittest

# Every check CI runs (.pre-commit-config.yaml), over the whole tree. Hooks that
# fix files (ruff, whitespace) fail the run that changed something, so a failed
# first pass gets a second one to confirm what is left.
lint:
	@prek run --all-files || prek run --all-files
