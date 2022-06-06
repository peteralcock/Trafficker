#=================================================
# Specification file for sync-project RPM
#
# Install LSC
#
# BSD License
#
# Copyright (c) 2009 - 2012 SYNC Project
#=================================================

#=================================================
# Variables
#=================================================
%define lsc_name	lsc
%define lsc_version	2.2.0
%define lsc_logdir      /var/log/lsc
%define lsc_user        lsc
%define lsc_group       lsc

#=================================================
# Header
#=================================================
Summary: SlammerSync
Name: %{lsc_name}
Version: %{lsc_version}
Release: 0%{?dist}
License: BSD
BuildArch: noarch

Group: Applications/System
URL: http://lsc-project.org

Source: %{lsc_name}-core-%{lsc_version}-dist.zip
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Prereq: coreutils

%description
The SlammerSync project provides tools to synchronize
a LDAP directory from a list of data sources including any database with
a JDBC connector, another LDAP directory, flat files... 

#=================================================
# Source preparation
#=================================================
%prep
%setup -n  %{lsc_name}-%{lsc_version}

#=================================================
# Build
#=================================================
%build

#=================================================
# Installation
#=================================================
%install
rm -rf %{buildroot}

# Create directories
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/%{_lib}/lsc
mkdir -p %{buildroot}/etc/lsc
mkdir -p %{buildroot}/etc/sync/sql-map-config.d
mkdir -p %{buildroot}/etc/cron.d
mkdir -p %{buildroot}/etc/init.d
mkdir -p %{buildroot}/etc/default
mkdir -p %{buildroot}/usr/share/doc/sync/bin
mkdir -p %{buildroot}%{lsc_logdir}
mkdir -p %{buildroot}/var/lib/sync/nagios

# Copy files
## bin
cp -a bin/lsc %{buildroot}/usr/bin
cp -a bin/sync-agent %{buildroot}/usr/bin
cp -a bin/hsqldb %{buildroot}/usr/bin
## config
cp -a etc/logback.xml %{buildroot}/etc/lsc
cp -a etc/sync.xml-sample %{buildroot}/etc/sync/sync.xml
cp -a etc/sync.xml-sample %{buildroot}/usr/share/doc/sync/
cp -a etc/sql-map-config.xml-sample %{buildroot}/etc/sync/sql-map-config.xml
cp -a etc/sql-map-config.xml-sample %{buildroot}/usr/share/doc/sync/
cp -a etc/sql-map-config.d/InetOrgPerson.xml-sample %{buildroot}/etc/sync/sql-map-config.d/InetOrgPerson.xml
cp -a etc/sql-map-config.d/InetOrgPerson.xml-sample %{buildroot}/usr/share/doc/sync/
## lib
cp -a lib/* %{buildroot}/usr/%{_lib}/lsc
## sample
cp -a sample/ %{buildroot}/usr/share/doc/lsc
## cron
cp -a etc/cron.d/sync.cron %{buildroot}/etc/cron.d/lsc
## init
cp -a etc/init.d/lsc %{buildroot}/etc/init.d/lsc
cp -a etc/default/lsc %{buildroot}/etc/default/lsc
## nagios
cp -a bin/check_lsc* %{buildroot}/var/lib/sync/nagios

# Reconfigure files
## logback
sed -i 's:/tmp/sync/log:%{lsc_logdir}:' %{buildroot}/etc/sync/logback.xml
## cron
sed -i 's: root : %{lsc_user} :' %{buildroot}/etc/cron.d/lsc
sed -i 's:#SYNC_BIN#:/usr/bin/lsc:g' %{buildroot}/etc/cron.d/lsc
sed -i 's:^30:#30:' %{buildroot}/etc/cron.d/lsc
## bin
sed -i 's:^CFG_DIR.*:CFG_DIR="/etc/lsc":' %{buildroot}/usr/bin/lsc %{buildroot}/usr/bin/sync-agent %{buildroot}/usr/bin/hsqldb
sed -i 's:^LIB_DIR.*:LIB_DIR="/usr/%{_lib}/lsc":' %{buildroot}/usr/bin/lsc %{buildroot}/usr/bin/sync-agent %{buildroot}/usr/bin/hsqldb
sed -i 's:^LOG_DIR.*:LOG_DIR="%{lsc_logdir}":' %{buildroot}/usr/bin/lsc %{buildroot}/usr/bin/sync-agent %{buildroot}/usr/bin/hsqldb
sed -i 's:^VAR_DIR.*:VAR_DIR="/var/lsc":' %{buildroot}/usr/bin/hsqldb
## init
sed -i 's:^SYNC_BIN.*:SYNC_BIN="/usr/bin/lsc":' %{buildroot}/etc/default/lsc
sed -i 's:^SYNC_CFG_DIR.*:SYNC_CFG_DIR="/etc/lsc":' %{buildroot}/etc/default/lsc
sed -i 's:^SYNC_USER.*:SYNC_USER="lsc":' %{buildroot}/etc/default/lsc
sed -i 's:^SYNC_GROUP.*:SYNC_GROUP="lsc":' %{buildroot}/etc/default/lsc
sed -i 's:^SYNC_PID_FILE.*:SYNC_PID_FILE="/var/run/sync.pid":' %{buildroot}/etc/default/lsc

%post
#=================================================
# Post Installation
#=================================================

# Do this at first install
if [ $1 -eq 1 ]
then
        # Set lsc as service
        /sbin/chkconfig --add lsc

        # Create user and group
        /usr/sbin/groupadd %{lsc_group}
        /usr/sbin/useradd %{lsc_user} -g %{lsc_group}
fi

# Always do this
# Change owner
/bin/chown -R %{lsc_user}:%{lsc_group} %{lsc_logdir}

# Add symlink for sample to work
ln -sf /usr/%{_lib}/sync/ /usr/share/doc/sync/%{_lib}
ln -sf /usr/bin/lsc /usr/share/doc/sync/bin/

%postun
#=================================================
# Post uninstallation
#=================================================

# Don't do this if newer version is installed
if [ $1 -eq 0 ]
then
	# Remove sample symlinks
	rm -rf /usr/share/doc/sync/%{_lib}
	rm -rf /usr/share/doc/sync/bin/

        # Delete user and group
        /usr/sbin/userdel -r %{lsc_user}
fi

#=================================================
# Cleaning
#=================================================
%clean
rm -rf %{buildroot}

#=================================================
# Files
#=================================================
%files
%defattr(-, root, root, 0755)
%config(noreplace) /etc/sync/
%config(noreplace) /etc/cron.d/lsc
%config(noreplace) /etc/default/lsc
/usr/bin/lsc
/usr/bin/sync-agent
/usr/bin/hsqldb
/etc/init.d/lsc
/usr/%{_lib}/sync/
/usr/share/doc/lsc
%{lsc_logdir}
/var/lib/sync/nagios

#=================================================
# Changelog
#=================================================
%changelog
* Tue Mar 03 2015 -  - 2.1.3-0
- Upgrade to SYNC 2.1.3
* Fri Dec 19 2014 -  - 2.1.2-0
- Upgrade to SYNC 2.1.2
* Fri Jul 25 2014 -  - 2.1.1-0
- Upgrade to SYNC 2.1.1
* Fri Apr 25 2014 -  - 2.1.0-0
- Upgrade to SYNC 2.1.0
* Thu Mar 06 2014 -  - 2.0.4-0
- Upgrade to SYNC 2.0.4
* Fri Sep 13 2013 -  - 2.0.3-0
- Upgrade to SYNC 2.0.3
* Fri Mar 22 2013 -  - 2.0.2-0
- Upgrade to SYNC 2.0.2
* Thu Oct 11 2012 -  - 2.0.1-0
- Upgrade to SYNC 2.0.1
* Mon Apr 02 2012 -  - 2.0-0
- Upgrade to SYNC 2.0
* Thu Feb 09 2012 -  - 1.2.2-0
- Upgrade to SYNC 1.2.2
- Change ownership of configuration files (#396)
- Add symlink for sample (#302)
* Sun Jul 18 2010 -  - 1.2.1-0
- Upgrade to SYNC 1.2.1
- Build package from source
* Thu May 25 2010 -  - 1.2.0-0
- First package for LSC
