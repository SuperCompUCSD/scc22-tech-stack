# BeeGFS Liqid

```
wget -q -O - https://www.beegfs.io/release/beegfs_7.3.2/gpg/GPG-KEY-beegfs \
	| sudo apt-key add -
sudo wget https://www.beegfs.io/release/beegfs_7.3.2/dists/beegfs-focal.list \
	-O /etc/apt/sources.list.d/beegfs.list
sudo apt update
sudo apt install beegfs-mgmtd beegfs-client beegfs-helperd beegfs-meta beegfs-storage
# https://doc.beegfs.io/7.3.2/advanced_topics/authentication.html#connectionbasedauth
sudo dd if=/dev/random of=/etc/beegfs/connauthfile bs=128 count=1
sudo chown root:root /etc/beegfs/connauthfile
sudo chmod 400 /etc/beegfs/connauthfile
# mgmgtd
sudoedit /etc/beegfs/beegfs-mgmtd.conf
storeMgmtdDirectory      = /mnt/beegfs-internal/mgmgtd
connAuthFile                           = /etc/beegfs/connauthfile
# clinet
sudoedit /etc/beegfs/beegfs-client.conf
sysMgmtdHost                  = 127.0.0.1
connAuthFile                  = /etc/beegfs/connauthfile
# meta
sudoedit /etc/beegfs/beegfs-meta.conf
sysMgmtdHost                 = 127.0.0.1
connAuthFile                  = /etc/beegfs/connauthfile
storeMetaDirectory           = /mnt/beegfs-internal/meta
# storage
sudoedit /etc/beegfs/beegfs-storage.conf
sysMgmtdHost                 = 127.0.0.1
connAuthFile                 = /etc/beegfs/connauthfile
storeStorageDirectory        = /mnt/beegfs-internal/storage
# helperd
sudoedit /etc/beegfs/beegfs-helperd.conf
connAuthFile       = /etc/beegfs/connauthfile
# fix if we have another driver installed
# https://groups.google.com/g/fhgfs-user/c/hQOY2_Rs2eE
sudoedit /etc/beegfs/beegfs-client-autobuild.conf
# buildArgs=-j8 OFED_INCLUDE_PATH=/usr/src/ofa_kernel/default/include
# buildArgs=-j8 OFED_INCLUDE_PATH=/usr/src/ofa_kernel/x86_64/5.15.0-52-generic/include
sudo systemctl restart beegfs-mgmtd.service beegfs-meta.service beegfs-storage.service beegfs-client.service beegfs-helperd.service
```

To add a Liqid drive to the storage target:

`sudo /opt/beegfs/sbin/beegfs-setup-storage -p /mnt/liquid8`

This adds the target and FS UUID to the config file separated by a comma.
Manual editing of the config file also works.
