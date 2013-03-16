#Modprobed_db
Modprobed_db will keep a running list of ALL modules ever probed on a system and allow for easy recall on demand. This is very useful for users wishing to build a minimal kernel via the make localmodconfig script which simply takes every module currently probed and switches everything BUT them off in the .config for a kernel resulting in smaller kernel packages and reduced compilation times.

SETUP

    $ make
Running a `make install` as root will distribute the files to the filesystem.

    # make install

Edit /etc/modprobed_db.conf and select a path where the database will reside (default is /var/log)
and optionally add some modules you wish to ignore to the ignore array. Some common ones are
included in the PKG by default.

USAGE

The most convenient method to "use" the script is to simply add an entry in the root user's crontab
to invoke /usr/bin/modprobed_db store at some regular interval.

Example running the script once every 20 minutes:

	# crontab -e
	*/20 * * * *   /usr/bin/modprobed_db store &> /dev/null

DATA RECALL

After the module database has been adequately populated, simply invoke /usr/bin/modprobed_db recall prior to compiling a kernel to load all modules followed by the make localmodconfig to do the magic.

#Links
AUR Package: https://aur.archlinux.org/packages/modprobed_db
