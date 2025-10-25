SHELL = /bin/bash -O globstar

.PHONY: build
build: pkgname.deb
	_SHYNUR_DEBFILENAME='$<';  \
		case $$HOSTTYPE in  \
			x86_64)  \
				rm -f $${_SHYNUR_DEBFILENAME%.deb}-x64.deb;  \
				cp $< $${_SHYNUR_DEBFILENAME%.deb}-x64.deb;  \
				;;  \
			aarch64)  \
				rm -f $${_SHYNUR_DEBFILENAME%.deb}-arm64.deb;  \
				cp $< $${_SHYNUR_DEBFILENAME%.deb}-arm64.deb;  \
				;;  \
		esac

pkgname.deb: FORCE
	$(MAKE) pkg.d/DEBIAN/control
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

pkg.d/DEBIAN/control: FORCE
	cd `dirname $@`;  \
		echo $$HOSTTYPE | python3 -c 'ar="arm64" if input()=="aarch64" else "amd64";from pathlib import Path;Path("control").write_text(Path("control.template").read_text(encoding="utf-8").replace("{{arch}}",ar))'

.PHONY: install
install: pkgname.deb
	sudo dpkg -i $<

remove: FORCE
	sudo dpkg -r my-time-printer

clean: FORCE
	rm -f   ./**/?*~   ./**/.?*~   ./**/\#?*\#   ./**/.\#?*
	rm -f  ./*.deb
	rm -f  pkg.d/DEBIAN/control

%/:
	mkdir -p $@
	-chmod -R a+rwx $@

FORCE:
