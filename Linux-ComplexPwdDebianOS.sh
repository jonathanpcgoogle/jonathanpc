#!/bin/bash
# Created by Jonathan. Its a DRAFT, review it before implement.
# 10 characters min. needs at least one Upper, Lower, Number and special. 
Cant change password for 2 days after changing. expires in 90 days with a 
warning 5 days before the end. As a max sequence or 3 so you cant have 
1234 or abcd. cant have google fireeye mandiant password in the password.

# Install password quality checking library
apt -y install libpam-pwquality
apt -y install libpam-passwdqc


# Back up /etc/security/pwquality.conf
cp /etc/security/pwquality.conf /etc/security/pwquality.bk
# uncomment and set minimum password length
perl -pi -e 's/# minlen = 8/minlen = 10/g' /etc/security/pwquality.conf
# uncomment and set minimum number of required classes of characters
perl -pi -e 's/# minclass = 0/minclass = 4/g' /etc/security/pwquality.conf
# uncomment and set maximum number of allowed consecutive same characters
perl -pi -e 's/# maxrepeat = 0/maxrepeat = 1/g' 
/etc/security/pwquality.conf
# uncomment and set maximum number of allowed consecutive characters of 
the same class
perl -pi -e 's/# maxclassrepeat = 0/maxclassrepeat = 10/g' 
/etc/security/pwquality.conf
# uncomment and set minimum lowercase character
perl -pi -e 's/# lcredit = 0/lcredit = -1/g' /etc/security/pwquality.conf
# uncomment and set minimum uppercase character
perl -pi -e 's/# ucredit = 0/ucredit = -1/g' /etc/security/pwquality.conf
# uncomment and set minimum other special character
perl -pi -e 's/# ocredit = 0/ocredit = -1/g' /etc/security/pwquality.conf
# uncomment and set minimum digit character
perl -pi -e 's/# dcredit = 0/dcredit = -1/g' /etc/security/pwquality.conf

# add to the end. Set maximum length of monotonic character sequences in 
the new password. (ex â‡’ '12345', 'fedcb')
echo 'maxsequence = 3' >> /etc/security/pwquality.conf
# add to the end. Set Ssace separated list of words that must not be 
contained in the password.
echo 'badwords = google fireeye mandiant password' >> 
/etc/security/pwquality.conf


# Back up /etc/pam.d/common-password 
cp /etc/login.defs /etc/login.bk
# set 90 for Password Expiration
perl -pi -e 's/PASS_MAX_DAYS	99999/PASS_MAX_DAYS	90/g' 
/etc/login.defs
# set 2 for Minimum number before they can change again
perl -pi -e 's/PASS_MIN_DAYS	0/PASS_MIN_DAYS	2/g' /etc/login.defs
# set 5 for number of days for warnings
perl -pi -e 's/PASS_WARN_AGE	7/PASS_WARN_AGE	/g' /etc/login.defs

# Back up /etc/pam.d/common-password 
cp /etc/pam.d/common-password /etc/pam.d/common-password.bk
rm /etc/pam.d/common-password
touch /etc/pam.d/common-password
cat > /etc/pam.d/common-password <<- "EOF"
#
# /etc/pam.d/common-password - password-related modules common to all 
services
#
# This file is included from other service-specific PAM config files,
# and should contain a list of modules that define the services to be
# used to change user passwords.  The default is pam_unix.

# Explanation of pam_unix options:
# The "yescrypt" option enables
#hashed passwords using the yescrypt algorithm, introduced in Debian
#11.  Without this option, the default is Unix crypt.  Prior releases
#used the option "sha512"; if a shadow password hash will be shared
#between Debian 11 and older releases replace "yescrypt" with "sha512"
#for compatibility .  The "obscure" option replaces the old
#`OBSCURE_CHECKS_ENAB' option in login.defs.  See the pam_unix manpage
#for other options.

# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.
# To take advantage of this, it is recommended that you configure any
# local modules either before or after the default block, and use
# pam-auth-update to manage selection of other modules.  See
# pam-auth-update(8) for details.

# here are the per-package modules (the "Primary" block)
password        requisite                       pam_pwquality.so retry=3 
minlen=10 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 minclass = 4 
enforce_for_root
password        requisite                       pam_passwdqc.so
password        [success=1 default=ignore]      pam_unix.so obscure 
use_authtok try_fi>
# here's the fallback if no module succeeds
password        requisite                       pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success 
code
# since the modules above will each just jump around
password        required                        pam_permit.so
# and here are more per-package modules (the "Additional" block)
password        optional        pam_gnome_keyring.so
# end of pam-auth-update config
		EOF


exit 0
