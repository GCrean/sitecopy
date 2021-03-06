#
# sitecopy Makefile: generated from Makefile.in.
#

SHELL = /bin/sh


# Installation paths
prefix = /usr
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
mandir = ${prefix}/man
man1dir = $(mandir)/man1
docdir = $(prefix)/doc/sitecopy
localedir = $(datadir)/locale
datadir = ${prefix}/share
pkgdatadir = $(datadir)/sitecopy

# Build paths.

top_srcdir = .
top_builddir = .

# Toolchain settings
LDFLAGS = 
INCLUDES = -I$(top_srcdir)/src -I$(top_srcdir)/lib
CPPFLAGS =  -D_LARGEFILE64_SOURCE -DNE_LFS  -I$(top_builddir) -DHAVE_CONFIG_H -DLOCALEDIR=\"$(localedir)\"
CFLAGS = -g -O2 -I$(top_srcdir)/lib/neon
ALL_CFLAGS = $(CPPFLAGS) $(INCLUDES) $(CFLAGS)
LIBS = -L$(top_builddir)/lib/neon -lneon  -L/usr/lib -lgssapi_krb5 -lkrb5 -lk5crypto -lcom_err -lexpat  
CC = gcc

# libintl must be built first.
SUBDIRS = intl lib/neon
EXPATDIR = lib/expat

INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
INSTALL = /usr/bin/install -c
mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs

##########################################################################
# Install paths and misc files required for a smooth Xsitecopy experience.
##########################################################################

DESKTOP_DIR = $(prefix)/share/gnome/apps/Internet
XSC_DESKTOP = $(top_srcdir)/gnome/share/xsitecopy.desktop

GHELPDIR = $(prefix)/share/gnome/help/xsitecopy
XSC_HELP = $(GHELPDIR)/C
PNG_DIR = $(prefix)/share/pixmaps/xsitecopy

GLADE_DIR = $(prefix)/share/xsitecopy
XSC_GLADE = $(top_srcdir)/gnome/share/sitecopy-dialogs.glade

# Target is the name of the executable
TARGET = sitecopy

OBJECTS = src/sites.o src/sitefiles.o src/sitestore.o \
	src/rcfile.o src/common.o src/nulldriver.o src/lsparser.o \
	 src/ftp.o src/ftpdriver.o src/davdriver.o src/rshdriver.o src/sftpdriver.o src/console_fe.o

GNOMEOBJS = gnome/changes.o gnome/minilist.o gnome/file_widgets.o \
	gnome/gcommon.o gnome/init.o gnome/main.o gnome/misc.o \
	gnome/new_site.o gnome/operations.o gnome/resynch.o \
	gnome/site_widgets.o gnome/tree.o

# The list of stuff which autoconf reckons we need to compile
# since the native libc hasn't got it.
LIBOBJS = lib/netrc.o lib/basename.o lib/dirname.o  lib/rpmatch$U.o lib/yesno$U.o

# Everything we want to compile into the target
ALLOBJS = $(OBJECTS) $(LIBOBJS)

DATAFILES = doc/examplerc doc/changes.awk
DOCS = README NEWS THANKS doc/update.sh
MANLANGS = fr

all: $(TARGET)

.PHONY: all again clean distclean reminders install-common	\
	install-sitecopy install-xsitecopy install-nls subdirs \
	ChangeLog

.SUFFIXES:
.SUFFIXES: .c .o

$(TARGET): subdirs $(ALLOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJECTS) $(LIBS) $(LIBOBJS)
	@echo
	@echo " Compilation complete. Run 'make install' to install sitecopy."
	@echo " (You may need to become root to do this)"
	@echo

subdirs: $(SUBDIRS)
	@for d in $(SUBDIRS); do \
	echo ">>> Entering $$d"; \
	(cd $$d && $(MAKE) all) || exit 1; \
	echo "<<< Leaving $$d"; \
	done

.c.o:
	$(CC) $(ALL_CFLAGS) -o $@ -c $<

Makefile: Makefile.in
	./config.status Makefile

# Various tester utils which can also be built.
#

# RFC1123 date/time tester
# netrc parser tester
netrc: lib/netrc.c
	$(CC) $(ALL_CFLAGS) -DSTANDALONE -o $@ $^

# Dependencies:

HEADERS = src/common.h src/frontend.h src/i18n.h src/protocol.h		\
	src/sites.h src/ftp.h src/lsparser.h src/rcfile.h src/sitesi.h	\
	lib/basename.h lib/dirname.h lib/fnmatch.h lib/getopt.h		\
	lib/netrc.h config.h

src/common.o: src/common.c $(HEADERS)
src/console_fe.o: src/console_fe.c $(HEADERS)
src/davdriver.o: src/davdriver.c $(HEADERS)
src/ftp.o: src/ftp.c $(HEADERS)
src/ftpdriver.o: src/ftpdriver.c $(HEADERS)
src/lsparser.o: src/lsparser.c $(HEADERS)
src/nulldriver.o: src/nulldriver.c $(HEADERS)
src/rcfile.o: src/rcfile.c $(HEADERS)
src/rshdriver.o: src/rshdriver.c $(HEADERS)
src/sitefiles.o: src/sitefiles.c $(HEADERS)
src/sites.o: src/sites.c $(HEADERS)
src/sitestore.o: src/sitestore.c $(HEADERS)
lib/basename.o: lib/basename.c lib/basename.h config.h
lib/dirname.o: lib/dirname.c lib/dirname.h config.h
lib/netrc.o: lib/netrc.c lib/netrc.h config.h
lib/rpmatch.o: lib/rpmatch.c config.h
lib/yesno.o: lib/yesno.c config.h

$(EXPATDIR)/xmltok/nametab.h: $(EXPATDIR)/gennmtab/gennmtab
	rm -f $@
	$(EXPATDIR)/gennmtab/gennmtab >$@

$(EXPATDIR)/gennmtab/gennmtab: $(top_srcdir)/$(EXPATDIR)/gennmtab/gennmtab.c
	$(CC) $(LDFLAGS) $(ALL_CFLAGS) -o $@ $(top_srcdir)/$(EXPATDIR)/gennmtab/gennmtab.c

$(EXPATDIR)/xmltok/xmltok.o: $(EXPATDIR)/xmltok/xmltok.c $(EXPATDIR)/xmltok/xmltok.h $(EXPATDIR)/xmltok/nametab.h

# The install goal is different for each front end, so
# we have a separate goal for each and autoconf points the 
# main 'install' goal at the FE we're compiling for.

install: $(TARGET) install-sitecopy install-nls

install-nls:
	@cd po && $(MAKE) install

install-common: $(TARGET)
	@echo "Creating directories..."
	$(mkinstalldirs) $(DESTDIR)$(bindir) $(DESTDIR)$(pkgdatadir) $(DESTDIR)$(docdir)
	@echo "Installing $(TARGET) executable..."
	$(INSTALL_PROGRAM) $(TARGET) $(DESTDIR)$(bindir)/$(TARGET)
	@echo "Installing data files..."
	set -e; for f in $(DATAFILES); do \
		$(INSTALL_DATA) $(top_srcdir)/$$f $(DESTDIR)$(pkgdatadir)/`echo $$f | sed 's/^doc\///'`; \
	done
	@echo "Installing documentation..."
	set -e; for f in $(DOCS); do \
		$(INSTALL_DATA) $(top_srcdir)/$$f $(DESTDIR)$(docdir)/`echo $$f | sed 's/^doc\///'`; \
	done

install-sitecopy: install-common
	@echo "Installing man page..."
	$(mkinstalldirs) $(DESTDIR)$(man1dir)
	$(INSTALL_DATA) $(top_srcdir)/doc/sitecopy.1 $(DESTDIR)$(man1dir)/sitecopy.1
	for f in $(MANLANGS); do $(mkinstalldirs) $(DESTDIR)$(mandir)/$$f/man1; \
		$(INSTALL_DATA) $(top_srcdir)/doc/sitecopy.$$f.1 \
			     $(DESTDIR)$(mandir)/$$f/man1/sitecopy.1; done
	@echo
	@echo "sitecopy installation finished."
	@echo

install-xsitecopy: install-common
	@echo Installing additional GNOME requirements...
	@echo Creating directories...
	$(mkinstalldirs) $(DESTDIR)$(GHELPDIR) $(DESTDIR)$(XSC_HELP) $(DESTDIR)$(DESKTOP_DIR) $(DESTDIR)$(PNG_DIR) $(DESTDIR)$(GLADE_DIR)
	@echo Installing help files...
	set -e; cd $(top_srcdir)/gnome/doc && for f in *.html topic.dat; do \
		$(INSTALL_DATA) $$f $(DESTDIR)$(XSC_HELP)/$$f; \
	done
	@echo Installing images...
	set -e; cd $(top_srcdir)/gnome/share && for f in *.png; do \
		$(INSTALL_DATA) $$f $(DESTDIR)$(PNG_DIR)/$$f; \
	done
	@echo Installing user-interface components...
	$(INSTALL_DATA) $(XSC_GLADE) $(DESTDIR)$(GLADE_DIR)/sitecopy-dialogs.glade
	@echo Adding desktop shortcut...
	$(INSTALL_DATA) $(XSC_DESKTOP) $(DESTDIR)$(DESKTOP_DIR)/xsitecopy.desktop
	@echo
	@echo "XSitecopy installation finished."
	@echo

clean:
	rm -f $(ALLOBJS)
	for d in $(SUBDIRS) po; do (cd $$d && $(MAKE) clean) || exit 1; done

again: clean
	$(MAKE) $(TARGET)

distclean: clean
	for d in intl lib/neon po; do \
	  if [ -f $$d/Makefile ]; then (cd $$d && $(MAKE) distclean); fi; \
	done
	rm -f config.h config.cache config.log config.status Makefile stamp-h core
	rm -f `find $(top_srcdir) \( -name '*.orig' -o -name '*.rej' \
		-o -name '#*#' -o -name '*~' \) -print`

ChangeLog:
	svn log > $@

