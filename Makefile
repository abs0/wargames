# Makefile for wargames

CFLAGS ?= -O2 -Wall
PREFIX ?= /usr/local
INSTALL_PROGRAM ?= install -m 0755
INSTALL_SCRIPT  ?= install -m 0755
INSTALL_DIR     ?= install -d

wopr: wopr.c
	$(CC) $(CFLAGS) -o ${.TARGET} ${.ALLSRC}

install:

install: wopr
	${INSTALL_DIR} ${DESTDIR}${PREFIX}/bin
	${INSTALL_PROGRAM} wopr ${DESTDIR}${PREFIX}/bin
	${INSTALL_SCRIPT} wargames.sh ${DESTDIR}${PREFIX}/bin/wargames

clean:
	rm -f wopr
