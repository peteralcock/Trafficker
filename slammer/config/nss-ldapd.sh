#!/bin/bash
# vim: softtabstop=4 shiftwidth=4 expandtab fenc=utf-8 spell spelllang=en cc=120
#  Setup nss-ldapd (OpenLDAP client) with SSH access
# Read more at: https://wiki.samba.org/index.php/Nslcd

set -e

# Check Ubuntu release
[ "$(lsb_release -sc)" = "trusty" ] || {
    echo 'This script should be run on Ubuntu 14.04.' >&2
    exit 1
}

# LDAP group name of team members to be granted access on this server,
LDAP_TEAM_NAME=$1
LDAP_BASE="dc=example,dc=com"
LDAP_URI="ldaps://ldap.example.com"
LDAP_BINDDN="cn=OpenLDAP Client,ou=users,dc=example,dc=com"
LDAP_BINDPW="password"

USAGE="usage: ./$(basename $0) LDAP_TEAM_NAME"

# Check required positional parameters
[ $# -ne 1 ] && {
    echo "$USAGE" >&2
    exit 1
}
# Install required packages
export DEBIAN_FRONTEND=noninteractive
apt-get -y install libpam-ldap nscd ldap-utils libnss-ldapd
apt-get -y install python-pip python-ldap
pip install ssh-ldap-pubkey

# Configure SSH server
grep 'AuthorizedKeysCommand' /etc/ssh/sshd_config > /dev/null || {
    cat >> /etc/ssh/sshd_config <<EOF
AuthorizedKeysCommand /usr/local/bin/ssh-ldap-pubkey-wrapper
AuthorizedKeysCommandUser nobody
EOF
}

# Restart SSH server
service ssh restart

# Edit /etc/ldap.conf
# If using nss-ldapd, /etc/ldap.conf will be not used by nslcd. However, it is
# still read by /usr/local/bin/ssh-ldap-pubkey-wrapper to authorize SSH users
mv /etc/ldap.conf /etc/ldap.conf.bak
cat > /etc/ldap.conf <<EOF
base $LDAP_BASE
uri $LDAP_URI
ldap_version 3
binddn $LDAP_BINDDN
bindpw $LDAP_BINDPW
pam_password md5
nss_initgroups_ignoreusers backup,bin,daemon,games,gnats,irc,landscape,libuuid,list,lp,mail,man,messagebus,news,pollinate,proxy,root,sshd,sync,sys,syslog,uucp,www-data
bind_timelimit 3
timelimit 3
EOF

cat > /etc/nslcd.conf <<EOF
uid nslcd
gid nslcd
uri $LDAP_URI
base $LDAP_BASE
binddn $LDAP_BINDDN
bindpw $LDAP_BINDPW
tls_reqcert never
nss_initgroups_ignoreusers ALLLOCAL
bind_timelimit 3
timelimit 3
reconnect_retrytime 3
EOF

# Edit /etc/ldap/ldap.conf
cp /etc/ldap/ldap.conf /etc/ldap/ldap.conf.bak
grep 'TLS_REQCERT' /etc/ldap/ldap.conf > /dev/null || {
    cat >> /etc/ldap/ldap.conf <<EOF
TLS_REQCERT     never
EOF
}

# Configure PAM
# Add pam_access.so
grep 'pam_access.so' /etc/pam.d/common-auth  > /dev/null || {
    cat >> /etc/pam.d/common-auth <<EOF
account required    pam_access.so
EOF
}

# Remove use_authtok from /etc/pam.d/common-password
sed -i -r 's/(.*)(use_authtok)(.*)/\1\3/g' /etc/pam.d/common-password

# Add pam_mkhomedir.so
grep 'pam_mkhomedir.so' /etc/pam.d/common-session > /dev/null || {
    cat >> /etc/pam.d/common-session <<EOF
session required    pam_mkhomedir.so skel=/etc/skel umask=0022
EOF
}

# Configure NSS
sed -i -r 's/(^passwd:)(\s+)(.*)/\1\2compat ldap/' /etc/nsswitch.conf
sed -i -r 's/(^group:)(\s+)(.*)/\1\2compat ldap/' /etc/nsswitch.conf
sed -i -r 's/(^shadow:)(\s+)(.*)/\1\2compat ldap/' /etc/nsswitch.conf

# Edit /etc/security/access.conf
grep -- '^- : ALL EXCEPT root' /etc/security/access.conf > /dev/null || {
    cat >> /etc/security/access.conf <<EOF
+ : ($LDAP_TEAM_NAME) : ALL    
- : ALL EXCEPT root staging-devops (admin) (wheel) : ALL EXCEPT LOCAL
EOF
}

# Edit /etc/sudoers
grep -F -- "%ldap-admin" /etc/sudoers > /dev/null || {
    cat >> /etc/sudoers <<EOF
%ldap-admin ALL=(ALL) ALL
EOF
}
grep -F -- "%$LDAP_TEAM_NAME" /etc/sudoers > /dev/null || {
    cat >> /etc/sudoers <<EOF
%$LDAP_TEAM_NAME ALL=(ALL) ALL
EOF
}

# Set vim as default editor
echo 3 | update-alternatives --config editor
echo

# Restart nscd
service nscd restart

# Restart nslcd
service nslcd restart
