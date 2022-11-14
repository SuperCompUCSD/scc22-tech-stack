# Neil (GPU Node) Configuration

In `~/.ssh/config`:
Must connect to the ethernet cable connected to the ethernet switch before
	being able to ssh (node not publically accessible)
```
Host scc-neil
    User y5jing
    Hostname 140.221.236.136
    HostKeyAlias scc-neil
    IdentityFile ~/.ssh/id_ed25519
    KbdInteractiveAuthentication no
Host scc-neil-ubuntu-22.04
    User y5jing
    HostName dust.sdsc.edu
    HostKeyAlias scc-neil-ubuntu-22.04
    IdentityFile ~/.ssh/id_ed25519
    KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
# Ubuntu 20.04
y5jing@neil:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:k/WRvfutkJ9pj8nlYVUMeCwrXvA1hcMajCUWlL58jFk root@dust (ED25519)
+--[ED25519 256]--+
|         .=*.+.o.|
|         .+.=oOo |
|         ..ooB.oo|
|         oo.E. ..|
|        So O. . .|
|         .* o. ..|
|           .o .o.|
|             +oOo|
|             .Oo=|
+----[SHA256]-----+
# Ubuntu 22.04
y5jing@neil:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:WRNXfOApsx62i9pafP6JlIktuDiFZ7ZGAKvI+nGs4S8 root@neil (ED25519)
+--[ED25519 256]--+
|          . .oo. |
|    .      o ....|
|     o    o o o. |
|    . .  o . +   |
|.. .   oS   +    |
|....  . *o = =   |
|. o o  *..= O    |
|..E=  ..o+ * o . |
| .+o. .o+oo +.o  |
+----[SHA256]-----+
```

## Config

- Use newest ROCM install and use DKMS with default kernel (6.0 won't work)
- Install BeeGFS
- Miniconda install
- Modify `/etc/environment` to have `/usr/local/miniconda3/bin:` prepended to `PATH`

In `/etc/netplan/00-installer-config.yaml``:
```
network:
  ethernets:
    enp5s0f0np0:
      dhcp4: true
    enp5s0f1np1:
      dhcp4: true
    enp12s0f0np0:
      dhcp4: true
    enp12s0f1np1:
      dhcp4: true
    enx7cc2c632258f:
      addresses:
      - 140.221.236.136/28
      routes:
      - to: default
        via: 140.221.236.129
      nameservers:
        search: [22.scconf.org, scconf.org]
        addresses: [140.221.249.246, 140.221.249.246]
  version: 2
```

If everything breaks, try:

```
network:
  ethernets:
    enp5s0f0np0:
      dhcp4: true
    enp5s0f1np1:
      dhcp4: true
    enp12s0f0np0:
      dhcp4: true
    enp12s0f1np1:
      dhcp4: true
    enx7cc2c632258f:
      # optional, works without it
      # dhcp4: true
      addresses:
      - 140.221.236.136/28
  version: 2
```


## Liquid RAID0

```
sudo mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=16 \
	/dev/nvme{0,1,2,3,4,5,6,7,10,11,12,13,14,15,16,17}n1
sudo mkfs.xfs /dev/md0
sudo mount /dev/md0 /mnt
```
