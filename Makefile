VERSION = 2.19
PN = modprobed_db

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man8
SKELDIR = $(PREFIX)/share/$(PN)
RM = rm
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed -i -e 's/@VERSION@/'$(VERSION)'/' common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and skel config...\033[0m'
	install -Dm755 common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	install -Dm644 common/$(PN).skel "$(DESTDIR)$(SKELDIR)/$(PN).skel"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).8 "$(DESTDIR)$(MANDIR)/$(PN).8"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).8"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).8.gz"
	$(Q)$(RM) -rf "$(DESTDIR)$(SKELDIR)"
