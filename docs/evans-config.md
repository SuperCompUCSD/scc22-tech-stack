# Evans (CPU B) Configuration

In `~/.ssh/config`:
```
Host scc-evans
	User y5jing
	HostName 192.31.21.253
	HostKeyAlias scc-evans
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
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