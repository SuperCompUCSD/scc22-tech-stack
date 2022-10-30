# Docs

This folder contains the documentation for the entire clsuter.  A more ephemeral version on Google Docs can be found
[here](https://docs.google.com/document/d/1luyosi0tw0CV6TYs07YhvxdxPlyeoI7M0kfBWWQhF6c).

## How to apply SSH config

See `man ssh_config` for details.  Also remember to change the `User` field and `IdentityFile`
field to correspond to your user & key file.

When asked about SSH pub key fingerprint, paste the string segment starting with SHA256 and ending with 4S8.

## How to extend drive

```
# replace 5G with 10G or however many you need
# this is an online operation, no need to unmount
sudo lvextend -rL +5G vgroot/lvroot-ubuntu-22.04
```

## LP64 vs ILP64

Ubuntu uses LP64, meaning `int` type is 32 bits.

Links
- <https://unix.org/version2/whatsnew/lp64_wp.html>
- <https://stackoverflow.com/questions/28750695/ubuntu-64-bit-is-lp64>
