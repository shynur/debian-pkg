SHELL = /bin/bash -O globstar

FORCE:
my_pkg: FORCE
	chmod a+x   usr/local/bin/a usr/local/bin/b
	chmod a+rw  lib/systemd/system/a.service
	chmod a+rwx DEBIAN
	chmod a+rw  DEBIAN/control
	dpkg-deb --build $@

