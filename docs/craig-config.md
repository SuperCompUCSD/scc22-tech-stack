# Craig (CPU A) Configuration

In `~/.ssh/config`:
```
Host scc-craig
	User y5jing
	HostName 192.31.21.251
	HostKeyAlias scc-craig
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
Host scc-craig-ubuntu-22.04
	User y5jing
	HostName 192.31.21.251
	HostKeyAlias scc-craig-ubuntu-22.04
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
# Ubuntu 20.04
y5jing@craig:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:YOhNe7EEjXfsFiQi1nPyP9Gl65SGe1ggFuftlZxw/dU root@craig (ED25519)
+--[ED25519 256]--+
|    o.oo.o.    ..|
|   . o=o=.= . o E|
|    . +*o* + * oo|
|   . + ++o* + = .|
|    . o.S+ = +   |
|       .  + B    |
|           O     |
|          o o    |
|           .     |
+----[SHA256]-----+
# Ubuntu 22.04
y5jing@craig:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:o/7VTXTl2jqQeoMMGPHk8lGoAjVZjIlG07wco17oPVw root@craig (ED25519)
+--[ED25519 256]--+
| .o=o*o ...     .|
|  +.O..=..     ..|
| . = +o.+     . o|
|  o = E= .   o + |
| o + o. S   o o .|
|  o +  . + + + . |
|     ..   = + +  |
|     .   . . . . |
|      ...        |
+----[SHA256]-----+
```

## Configuration Status

- General config is done
- SMT is disabled

# Particularities

- Used Ubuntu default LVM conventions
- No separate `/home` LV or partition
- All disk space used up

In `/etc/netplan/00-installer-config.yaml`
```
network:
  ethernets:
    enp68s0f0:
      dhcp4: true
    enp68s0f1:
      dhcp4: true
    enp68s0f2:
      dhcp4: true
    enp68s0f3:
      dhcp4: true
    enp129s0f0np0:
      addresses:
      - 10.0.1.5/24
      routes:
      - to: 10.0.1.4
        via: 10.0.1.5
    enp129s0f1np1:
      addresses:
      - 10.0.1.6/24
      routes:
      - to: 10.0.1.2
        via: 10.0.1.6
  version: 2
```
