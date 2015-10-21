## edg-passwd
A simple program for users to use to keep linux and samba passwords in sync

## Example
```bash
$ ./edg-passwd 
Changing password for user art
(current) password: 
New password: 
Retype new password: 
Password changed
```

## To Do

### Replacement for smbpasswd
I *think* I could rename this script to smbpasswd so that when a user tried to change their password in windows, it would automatically change the linux one as well. Or try to find another way to have windows users call this script when attempting to change their password.  Reason is, the first password that's checked in this script is actually the unixPassword entry.  Also, for rails apps that authenticate against this system, they are also using the unixPassword entry.  

### Tests
Haven't written any yet.  On my list of things to do.

