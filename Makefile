PREFIX=/usr/local

bm: bm.sh
	cat bm.sh > $@
	echo 'exit 0' >> $@
	echo '#EOF' >> $@
	chmod +x $@

test: bm.sh
	shellcheck -s sh bm.sh

clean:
	rm -f bm

install: bm
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f bm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/bm

uninstall: 
	rm -f ${DESTDIR}${PREFIX}/bin/bm

