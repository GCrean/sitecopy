# Emacs, please be in spec-file-mode: -*- rpm-spec -*-

Summary: Tool for easily maintaining remote web sites
Name: sitecopy
Version: 0.16.3
Release: 1
License: GPL
Group: Applications/Internet
Source0: http://www.lyra.org/sitecopy/sitecopy-%{version}.tar.gz
URL: http://www.lyra.org/sitecopy/
BuildRoot: /var/tmp/sitecopy-%{version}-root
BuildRequires: expat-devel

%description
sitecopy allows you to easily maintain remote Web sites.  The program
will upload files to the server which have changed locally, and delete
files from the server which have been removed locally, to keep the
remote site synchronized with the local site, with a single
command. sitecopy will also optionally try to spot files you move
locally, and move them remotely.  FTP and WebDAV servers are
supported.

%prep
%setup -q

%build
%configure --enable-debug --with-expat
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install docdir=%{_datadir}/doc/sitecopy-%{version} DESTDIR=$RPM_BUILD_ROOT 

%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files -n sitecopy -f %{name}.lang
%defattr(-, root, root)
%{_bindir}/sitecopy
%{_mandir}/man1/*
%{_mandir}/*/man1/*
%{_datadir}/sitecopy
%doc COPYING ChangeLog INSTALL NEWS README* THANKS TODO

%changelog
* Sat Aug 13 2005 Joe Orton <joe@manyfish.co.uk>
- remove xsitecopy subpackage
- use find_lang
- use %%configure
- general clean up

* Sun Jan 13 2002 Joe Orton <joe@manyfish.co.uk>
- Use DESTDIR in make install.

* Sun Jan  6 2002 Joe Orton <joe@manyfish.co.uk>
- Add -q argument to %setup, better %description, minor cleanups.

* Sun Oct 29 2000 Joe Orton <joe@light.plus.com>
- Fix man page location (Nobuyuki Tsuchimura).

* Tue Jun 27 2000 Nobuyuki Tsuchimura <tutimura@nn.iij4u.or.jp>
- Include 'LC_MESSAGES/sitecopy.mo'.
- Don't install in %build section.
- Add more documents and '/usr/share/sitecopy/*'.
- Correct URL.

* Sat Apr 22 2000 Lee Mallabone <lee0@callnetuk.com>
- Bring up to date for latest xsitecopy stuff

* Mon Jul 26 1999 Joe Orton <joe@orton.demon.co.uk>
- Enabled debugging for sitecopy and xsitecopy.

* Fri May 28 1999 Dobrica Pavlinusic <dpavlin@foi.hr>
- integrated into GNU configure to automaticly pick up version number

* Sat Apr 3 1999 Lee Mallabone <lee0@callnetuk.com>
- After a few tweaks, it now actually works. :)

* Thu Apr 1 1999 Lee Mallabone <lee0@callnetuk.com>
- first attempt.
