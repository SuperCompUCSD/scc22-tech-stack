# Evans (CPU B) Configuration

In `~/.ssh/config`:
```
Host evans
	User udxs
	HostName 192.31.21.253
	HostKeyAlias evans
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
udxs@evans:~$  ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
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

udxs@evans:~$ ssh-keygen -lvf /etc/ssh/ssh_host_rsa_key.pub
3072 SHA256:h9YIj02OuhMEzX9ZLYUe99c2+hSNcm9Z33VhTXvNhLg root@evans (RSA)
+---[RSA 3072]----+
|   o       +.. o+|
|  . o     = + .=+|
|   . .. .+ + o.oB|
|    . .Oo+. E +oX|
|   .  o.S o  o.+X|
|    .. . .   . o=|
|    ..        o. |
|    ..         . |
|    ..           |
+----[SHA256]-----+
```

## Configuration Status

- General config is done
- SMT is disabled

# Particularities

- Used Ubuntu default LVM conventions
- No separate `/home` LV or partition
- All disk space used up