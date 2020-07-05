# Modprobed-db
Modprobed-db is a useful utility for users wishing to build a minimal kernel via a [make localmodconfig](https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/README?id=refs/tags/v4.3.3#n205). In a nutshell, this make target creates a config based on the current config and a list of modules you define (modprobed-db keeps for you). It then disables any module option that is not needed thus not building hundreds/potentially thousands of extraneous modules. This results in a system-specific, streamlined kernel package and footprint as well as reduced compilation times.

Modprobed-db simply logs every module ever probed on the target system to a text-based database (`$XDG_CONFIG_HOME/modprobed-db`) which can be read directly by "make localmodconfig" as described above.

# Installation
`$ make`

Running a make install as root will distribute the files to the filesystem.

`# make install`

# Usage
Refer to the man page `man modprobed-db`

# Links
AUR Package: https://aur.archlinux.org/packages/modprobed-db
