# dlocate - dmenu locate gui
# See LICENSE file for copyright and license details.

include config.mk

SRC = dlocate.c draw.c 
OBJ = ${SRC:.c=.o}

all: options dlocate 

options:
	@echo dlocate build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC -c $<
	@${CC} -c $< ${CFLAGS}

${OBJ}: config.mk draw.h

dlocate: dlocate.o draw.o
	@echo CC -o $@
	@${CC} -o $@ dlocate.o draw.o ${LDFLAGS}


clean:
	@echo cleaning
	@rm -f dlocate ${OBJ} dlocate-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p dlocate-${VERSION}
	@cp LICENSE Makefile README config.mk dmenu.1 draw.h dlocate_run ${SRC} dlocate-${VERSION}
	@tar -cf dlocate-${VERSION}.tar dlocate-${VERSION}
	@gzip dlocate-${VERSION}.tar
	@rm -rf dlocate-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f dlocate dlocate_run ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dlocate
	@chmod 755 ${DESTDIR}${PREFIX}/bin/dlocate_run
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < dmenu.1 > ${DESTDIR}${MANPREFIX}/man1/dmenu.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/dmenu.1

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/dlocate
	@rm -f ${DESTDIR}${PREFIX}/bin/dlocate_run
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/dmenu.1

.PHONY: all options clean dist install uninstall
