# Neil (GPU Node) Configuration

In `~/.ssh/config`:
```
Host scc-neil
    User y5jing
    HostName dust.sdsc.edu
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

- Change all interfaces to optional in `/etc/netplan/00-installer-config.yaml` to prevent boot lag
- Use newest ROCM install and use DKMS with default kernel (6.0 won't work)
- Install BeeGFS
- Miniconda install
- Modify `/etc/environment` to have `/usr/local/miniconda3/bin:` prepended to `PATH`

In `/etc/netplan/01-static-ip.yaml`:
```
network:
  ethernets:
    enp5s0f1np1:
      dhcp4: no
      addresses: [192.31.21.127/24]
      routes:
        - to: default
          via: 192.31.21.1
      nameservers:
        addresses: [132.249.20.25,198.202.75.26]
```
