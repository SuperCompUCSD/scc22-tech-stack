# General Configuration for all nodes

## Installation

- Install Ubuntu 20.04 via Ventoy
  - Make a 1-2G boot partition at the end of the drive & an LVM partition before it
  - `sudo pvcreate </dev/pv-partition>`
  - `sudo vgcreate vgroot /dev/mapper/pvroot`
  - `sudo lvcreate -n lvroot -L 15G vgroot`
  - `sudo lvcreate -n lvhome -L 10G vgroot`
  - ([Details here](https://git.duckduckwhale.com/DuckDuckWhale/dotfiles/src/commit/e92fa0f73c043bf0d7585f8d11eb4d93714d3a45/setup/dual-boot-ubuntu.md))
- Install SSH & Mosh & configure firewall (details linked below)

Details can be found in
[my personal dotfiles](https://git.duckduckwhale.com/DuckDuckWhale/dotfiles/src/commit/e92fa0f73c043bf0d7585f8d11eb4d93714d3a45/setup/ubuntu-setup.md).

## Kernel 5.15.0

- `sudo apt install linux-image-unsigned-5.15.0-52-generic linux-modules-5.15.0-52-generic
  linux-headers-5.15.0-52-generic linux-modules-extra-5.15.0-52-generic`

## Shared home folder

```
sudo mkdir /home/shared
sudo chgrp ssh-users /home/shared
sudo chmod ug+rwx,g+s,o-rwx /home/shared
```

## Rip out snap

```
# if this command fails, unmount the snap mounts as reported by `mount` and try again
sudo apt autoremove --purge snapd
sudo apt-mark hold snapd
```

## Wall to Discord

```
sudo apt install -y jq
sudo tee /usr/local/bin/wall > /dev/null << 'EOF'
#!/bin/sh -e
curl \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USER@$(hostname)\", \"content\": $(echo -n "@everyone $@" | jq -Rsa .)}" \
"https://discord.com/api/webhooks/1035726576983228466/7_3HcSnwltdxMDSXLpRUUP3XrJ-thexqNLTJj346Yj3aQvU2jeTMQBQMKOG7rVwJB3N0"
/usr/bin/wall "$@"
EOF
sudo chmod a+x /usr/local/bin/wall
```

## Disable SMT

How do disable SMT: ask Davit

To check if SMT is disabled:
`cat /sys/devices/system/cpu/smt/active`

## AMD BLIS

- First option in <https://developer.amd.com/amd-aocl/blas-library/>

```
sudo cp -ri include/LP64/* /usr/local/include/
sudo cp -ri lib/LP64/* /usr/local/lib/
cd /usr/local/include/
sudo chmod u=rw,go=r blis.h blis.hh cblas.h cblas.hh
cd /usr/local/lib/
sudo chmod u=rw,go=r libblis-mt.a libblis-mt.so libblis-mt.so.3 libblis-mt.so.3.2.0 libblis.a libblis.so libblis.so.3 libblis.so.3.2.0
```
