SHELL = /bin/bash -O globstar

pkgname.deb: FORCE
	rm -f $@
	cd pkg.d;  \
		chmod a+rwx usr/local/bin/*;  \
		chmod a+rx  lib/;  \
		chmod a+rx  lib/systemd/;  \
		chmod a+rwx lib/systemd/system/;  \
		chmod a+rw  lib/systemd/system/*.service;  \
		chmod 775   DEBIAN/;  \
		chmod 775   DEBIAN/{post,pre}{inst,rm};  \
		chmod a+rw  DEBIAN/control
	dpkg-deb -z0 -Znone -vD --build pkg.d $@

.PHONY: install
install: pkgname.deb
	sudo dpkg -i $<

remove: FORCE
	sudo dpkg -r my-time-printer

clean: FORCE
	rm -f   ./**/?*~   ./**/.?*~   ./**/\#?*\#   ./**/.\#?*
	rm -f  ./*.deb

%/:
	mkdir -p $@
	-chmod -R a+rwx $@

FORCE:
