SHELL = /bin/bash -O globstar

debian-pkgname.deb: FORCE
	chmod a+x   usr/local/bin/*
	chmod a+rw  lib/systemd/system/*.service
	chmod 775   DEBIAN DEBIAN/postinst
	chmod a+rw  DEBIAN/control
	_CUR_DIR_NAME=`basename $$PWD`;  \
		cd ..;  \
		dpkg-deb --build $$_CUR_DIR_NAME
	mv ../`basename $$PWD`.deb .
	mv `basename $$PWD`.deb $@

install: debian-pkgname.deb
	sudo dpkg -i $<

remove: FORCE
	sudo systemctl stop    print-time-everysecond-d
	sudo systemctl disable print-time-everysecond-d
	sudo dpkg -r my-time-printer
	sudo rm -f /tmp/shynur.ws.debian-pkg.log.txt


.PHONY: FORCE
clean:
	rm -f   ./**/?*~   ./**/.?*~   ./**/\#?*\#   ./**/.\#?*
	rm -rf  bin
	rm -f  ./**/?*.el[cn]
	rm -f  ./**/?*.{so,dylib,dll}
	rm -f  ./*.deb

%/:
	mkdir -p $@
	-chmod -R a+rwx $@

FORCE:
