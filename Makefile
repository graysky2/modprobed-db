VERSION = 2.18
PN = modprobed_db

PREFIX ?= /usr
CONFDIR = /etc
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man8

RM = rm
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed -i -e 's/@VERSION@/'$(VERSION)'/' common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and config...\033[0m'
	install -Dm644 common/$(PN).conf "$(DESTDIR)$(CONFDIR)/$(PN).conf"
	install -Dm755 common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	install -Dm644 doc/$(PN).8 "$(DESTDIR)$(MANDIR)/$(PN).8"
	gzip -9 "$(DESTDIR)$(MANDIR)/$(PN).8"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).8.gz"
	$(Q)echo -e '\033[1;33mIf you want to remove your config as well, run: "make uninstall-conf"\033[0m'

uninstall-conf:
	$(RM) "$(DESTDIR)$(CONFDIR)/modprobed_db.conf"
