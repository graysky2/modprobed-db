VERSION = 2.26
PN = modprobed-db

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man8
SKELDIR = $(PREFIX)/share/$(PN)
ZSHDIR = $(PREFIX)/share/zsh/site-functions

RM = rm
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and skel config...\033[0m'
	install -Dm755 common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	install -Dm644 common/$(PN).skel "$(DESTDIR)$(SKELDIR)/$(PN).skel"

	# symlink for compatibility due to name change
	ln -s $(PN) "$(DESTDIR)$(BINDIR)/modprobed_db"

	install -d "$(DESTDIR)$(ZSHDIR)"
	install -m644 common/zsh-completion "$(DESTDIR)/$(ZSHDIR)/_modprobed-db"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).8 "$(DESTDIR)$(MANDIR)/$(PN).8"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).8"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).8.gz"
	$(Q)$(RM) -rf "$(DESTDIR)$(SKELDIR)"
	$(Q)$(RM) "$(DESTDIR)/$(ZSHDIR)/_modprobed-db"
