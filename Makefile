VERSION = 2.32
PN = modprobed-db

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man8
INITDIR_SYSTEMD = /usr/lib/systemd/system
SKELDIR = $(PREFIX)/share/$(PN)
ZSHDIR = $(PREFIX)/share/zsh/site-functions

INSTALL = install -p
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
INSTALL_DIR = $(INSTALL) -d

RM = rm --recursive --force
Q = @

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and skel config...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(BINDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(SKELDIR)"
	$(INSTALL_PROGRAM) common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(INSTALL_DATA) common/$(PN).skel "$(DESTDIR)$(SKELDIR)/$(PN).skel"

	# symlink for compatibility due to name change
	ln --force --symbolic $(PN) "$(DESTDIR)$(BINDIR)/modprobed_db"
	$(INSTALL_DIR) "$(DESTDIR)$(ZSHDIR)"
	$(INSTALL_DATA) common/zsh-completion "$(DESTDIR)$(ZSHDIR)/_modprobed-db"
	
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR_SYSTEMD)"
	$(INSTALL_DATA) init/modprobed-db@.service "$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db@.service"
	$(INSTALL_DATA) init/modprobed-db@.timer "$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db@.timer"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(MANDIR)"
	cat "doc/$(PN).8" | gzip --force -9 > "doc/$(PN).8.gz"
	$(INSTALL_DATA) "doc/$(PN).8.gz" "$(DESTDIR)$(MANDIR)"

install: install-bin install-man

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).8.gz"
	$(Q)$(RM) "$(DESTDIR)$(SKELDIR)"
	$(Q)$(RM) "$(DESTDIR)$(ZSHDIR)/_modprobed-db"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db@*"
