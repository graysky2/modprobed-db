VERSION = 2.49
PN = modprobed-db

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DOCDIR = $(PREFIX)/share/doc/$(PN)-$(VERSION)
MANDIR = $(PREFIX)/share/man/man8
INITDIR_SYSTEMD = /usr/lib/systemd/user
INITDIR_OPENRC ?= /etc/init.d
CONFDIR_OPENRC ?= /etc/conf.d

SKELDIR = $(PREFIX)/share/$(PN)
BASHDIR = $(PREFIX)/share/bash-completion/completions
ZSHDIR = $(PREFIX)/share/zsh/site-functions

INSTALL = install -p
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644
INSTALL_DIR = $(INSTALL) -d

RM = rm -f
Q = @

# default: use systemd unless explicitly overridden
WITH_OPENRC ?= 0

all:
	$(Q)echo -e '\033[1;32mSetting version\033[0m'
	$(Q)sed 's/@VERSION@/'$(VERSION)'/' common/$(PN).in > common/$(PN)

install-bin:
	$(Q)echo -e '\033[1;32mInstalling main script and skel config...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(BINDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(SKELDIR)"
	$(INSTALL_PROGRAM) common/$(PN) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(INSTALL_DATA) common/$(PN).skel "$(DESTDIR)$(SKELDIR)/$(PN).skel"

	$(INSTALL_DIR) "$(DESTDIR)$(BASHDIR)"
	$(INSTALL_DATA) common/bash-completion "$(DESTDIR)$(BASHDIR)/modprobed-db"
	$(INSTALL_DIR) "$(DESTDIR)$(ZSHDIR)"
	$(INSTALL_DATA) common/zsh-completion "$(DESTDIR)$(ZSHDIR)/_modprobed-db"

install-man:
	$(Q)echo -e '\033[1;32mInstalling manpage...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(MANDIR)"
	$(INSTALL_DATA) doc/$(PN).8 "$(DESTDIR)$(MANDIR)/$(PN).8"

install-systemd:
ifeq ($(WITH_OPENRC),1)
	@echo "Skipping systemd install (WITH_OPENRC=1)"
else
	$(Q)echo -e '\033[1;32mInstalling SystemD service files...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR_SYSTEMD)"
	$(INSTALL_DATA) init/modprobed-db.service \
		"$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db.service"
	$(INSTALL_DATA) init/modprobed-db.timer \
		"$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db.timer"
endif

install-openrc:
ifeq ($(WITH_OPENRC),1)
	$(Q)echo -e '\033[1;32mInstalling OpenRC service files...\033[0m'
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR_OPENRC)"
	$(INSTALL_DIR) "$(DESTDIR)$(CONFDIR_OPENRC)"

	$(INSTALL_PROGRAM) init/modprobed-db.in \
		"$(DESTDIR)$(INITDIR_OPENRC)/modprobed-db"

	$(INSTALL_PROGRAM) init/modprobed-db_timer.in \
		"$(DESTDIR)$(INITDIR_OPENRC)/modprobed-db-timer"

	# optional config (only install if present)
	[ -f init/modprobed-db.confd ] && \
		$(INSTALL_DATA) init/modprobed-db.confd \
		"$(DESTDIR)$(CONFDIR_OPENRC)/modprobed-db-timer" || true
else
	@echo "Skipping OpenRC install (WITH_OPENRC=0)"
endif

install: install-bin install-man
ifeq ($(WITH_OPENRC),1)
	$(MAKE) install-openrc
else
	$(MAKE) install-systemd
endif

uninstall:
	$(Q)$(RM) "$(DESTDIR)$(BINDIR)/$(PN)"
	$(Q)$(RM) "$(DESTDIR)$(MANDIR)/$(PN).8"
	$(Q)$(RM) -rf "$(DESTDIR)$(SKELDIR)"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db.service"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_SYSTEMD)/modprobed-db.timer"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_OPENRC)/modprobed-db"
	$(Q)$(RM) "$(DESTDIR)$(INITDIR_OPENRC)/modprobed-db-timer"
	$(Q)$(RM) "$(DESTDIR)$(CONFDIR_OPENRC)/modprobed-db-timer"
	$(Q)$(RM) "$(DESTDIR)$(ZSHDIR)/_modprobed-db"
	$(Q)$(RM) "$(DESTDIR)$(BASHDIR)/modprobed-db"
