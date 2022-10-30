# CPU A Configuration

In `~/.ssh/config`:
```
Host scc-cluster-cpua
	User y5jing
	HostName 192.31.21.252
	HostKeyAlias scc-cluster-cpua
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
```

SSH host key fingerprint:
```
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
