# Evans (CPU B) Configuration

In `~/.ssh/config`:
```
Host scc-evans
	User y5jing
	HostName 140.221.236.140
	HostKeyAlias scc-evans
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
Host scc-evans-ubuntu-22.04
	User y5jing
	HostName 140.221.236.140
	HostKeyAlias scc-evans-ubuntu-22.04
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
# Ubuntu 20.04
y5jing@evans:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:GvO3OpgHiX3JhdEDlnZun6iIaE4V3m9UcLdSFTLs7hA root@evans (ED25519)
+--[ED25519 256]--+
|        ++..=.o. |
|       .+o+o.+   |
|    .  . =oo.    |
|   . o  ..E..    |
|    oo+oS+ = .   |
|   .. +B+ o +    |
|  .. ..*+..o     |
| .o . +.+. ..    |
| o.    ..o.      |
+----[SHA256]-----+
# Ubuntu 22.04
udxs@evans:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:3y3siv7riIwccpFUbOuKpMqU2FIA9tFp5TbsVPgP5HA root@evans (ED25519)
+--[ED25519 256]--+
|.. ...+...       |
|o . .==o.E       |
|.  .o. B*        |
| . . .= .+       |
|  . o. .S o      |
|.oo  ..  . + .   |
|o=o.o.    . + .  |
|+..+.+ . o . .   |
|o.  o o.+o=o.    |
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
	      addresses:
	      - 192.31.21.253/24
	      gateway4: 192.31.21.1
	    enp68s0f1:
	      dhcp4: true
	    enp161s0f0np0:
	      addresses:
	      - 10.0.1.3/24
	      routes:
	      - to: 10.0.1.1
	        via: 10.0.1.3
	    enp161s0f1np1:
	      addresses:
	      - 10.0.1.4/24
	      routes:
	      - to: 10.0.1.5
	        via: 10.0.1.4
	  version: 2
```
