# Raspberry Pi Configuration

Mode: RPI 3

In `~/.ssh/config`:
```
Host scc-pi
	User y5jing
	HostName bunny.sdsc.edu
	HostKeyAlias scc-pi
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
Host scc-pi-bmc
	# https://localhost:22220
	User y5jing
	HostName bunny.sdsc.edu
	HostKeyAlias scc-pi
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
	LocalForward 127.0.0.1:22220 192.168.4.20:443
	ExitOnForwardFailure yes
	SessionType none
	RequestTTY no
	StdinNull yes
Host scc-pi-pdu
	# http://localhost:22221
	User y5jing
	HostName bunny.sdsc.edu
	HostKeyAlias scc-pi
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
	LocalForward 127.0.0.1:22221 192.168.4.4:80
	ExitOnForwardFailure yes
	SessionType none
	RequestTTY no
	StdinNull yes
Host scc-pi-craig-bmc
	# https://localhost:22222
	User y5jing
	HostName bunny.sdsc.edu
	HostKeyAlias scc-pi
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
	LocalForward 127.0.0.1:22222 192.168.4.22:443
	ExitOnForwardFailure yes
	SessionType none
	RequestTTY no
	StdinNull yes
Host scc-pi-evans-bmc
	# https://localhost:22223
	User y5jing
	HostName bunny.sdsc.edu
	HostKeyAlias scc-pi
	IdentityFile ~/.ssh/id_ed25519-ucsd
	KbdInteractiveAuthentication no
	LocalForward 127.0.0.1:22223 192.168.4.23:443
	ExitOnForwardFailure yes
	SessionType none
	RequestTTY no
	StdinNull yes
```

SSH host key fingerprint:
```
y5jing@miniman:~$ ssh-keygen -lvf /etc/ssh/ssh_host_ed25519_key.pub
256 SHA256:iRAFlJvRw/yDxIgmFUzNlRzF/kjuOSokY6RfkAGQSN0 root@ubuntu (ED25519)
+--[ED25519 256]--+
|*B=*=%+=.        |
|+ =.*EX .        |
| o o.= =         |
|  + o...=.       |
| o .  .oS+       |
|. + o   o .      |
| o =   . .       |
|  . .   +        |
|     ... .       |
+----[SHA256]-----+
```

## Networking

The main Ethernet port provides Internet access, while each BMC is attached via a Ethernet to USB adapter.

In `/etc/netplan/00-networking.yaml`:
```
network:
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.31.21.197/24]
      routes:
        - to: default
          via: 192.31.21.1
      nameservers:
        addresses: [132.249.20.25,198.202.75.26]
    enx00e01e700091:
      dhcp4: no
      addresses: [192.168.4.69/24]
      routes:
        - to: 192.168.4.20
    enx7cc2c6447e33:
      dhcp4: no
      addresses: [192.168.4.21/24]
      routes:
        - to: 192.168.4.22
    enx7cc2c632258f:
      dhcp4: no
      addresses: [192.168.4.99/24]
      routes:
        - to: 192.168.4.23
  version: 2
```
Add one interface for each additional device.  After making changes, `sudo netplan apply`.

## Samba

```
sudo apt install samba
sudo ufw allow samba
TODO https://ubuntu.com/tutorials/install-and-configure-samba#3-setting-up-samba
[public]
    comment = 2muchcache public samba share
    path = /home/shared/sambashare/public
    guest ok = yes
    read only = yes
    browsable = yes
# TODO perm  interfaces
sudo service smbd restart
sudo smbpasswd -a username

```

## Grafana

TODO: need Anders to fill this out
