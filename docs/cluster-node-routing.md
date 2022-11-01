# Port Guids, ips, & routes
| Node  | HCA ID | GUID             | IP interface | IP          | Dest Route |
| ----- | ------ | ---------------- | ------------ | ----------- | ---------- |
| Neil  | mlx5_2 | e8ebd30300d63630 | ibp12s0f0    | 10.0.1.1/24 | 10.0.1.3   |
|       | mlx5_3 | e8ebd30300d63631 | ibp12s0f1    | 10.0.1.2/24 | 10.0.1.6   |
| Evans | mlx5_0 | e8ebd303000b1750 | ibp161s0f0   | 10.0.1.3/24 | 10.0.1.1   |
|       | mlx5_1 | e8ebd303000b1751 | ibp161s0f1   | 10.0.1.4/24 | 10.0.1.5   |
| Craig | mlx5_0 | e8ebd303000b2f90 | ibp129s0f0   | 10.0.1.5/24 | 10.0.1.4   |
|       | mlx5_1 | e8ebd303000b2f91 | ibp129s0f1   | 10.0.1.6/24 | 10.0.1.2   |

# ib Connections 
| Src Node | Src HCA | Src GUID         | ->  | Dest Node | Dest HCA | Dest GUID        |
| -------- | ------- | ---------------- | --- | --------- | -------- | ---------------- |
| Niel     | mlx5_2  | e8ebd30300d63630 | ->  | Evans     | mlx5_0   | e8ebd303000b2f90 |
|          | mlx5_3  | e8ebd30300d63631 | ->  | Craig     | mlx5_1   | e8ebd303000b1751 |
| Evans    | mlx5_0  | e8ebd303000b2f90 | ->  | Niel      | mlx5_2   | e8ebd30300d63630 |
|          | mlx5_1  | e8ebd303000b2f91 | ->  | Craig     | mlx5_0   | e8ebd303000b1750 |
| Craig    | mlx5_0  | e8ebd303000b1750 | ->  | Evans     | mlx5_1   | e8ebd303000b2f91 |
|          | mlx5_1  | e8ebd303000b1751 | ->  | Neil      | mlx5_3   | e8ebd30300d63631 |

# ConnectX 6 to ethernet mode
https://www.youtube.com/watch?v=XLPgDEbUMgkw

# `.ssh/config` between nodes
## Neil
```
HOST craig
	Hostname 10.0.1.6

Host evans
	Hostname 10.0.1.3
```
## Evans
```
HOST neil
	Hostname 10.0.1.1

Host craig
	Hostname 10.0.1.5
```
## Craig
```
HOST neil
	Hostname 10.0.1.2

Host evans
	Hostname 10.0.1.4
```

# `ibv_devices`
## Neil
```
hca_id: mlx5_0
        transport:                      InfiniBand (0)
        fw_ver:                         16.34.1002
        node_guid:                      1070:fd03:001e:21a6
        sys_image_guid:                 1070:fd03:001e:21a6
        vendor_id:                      0x02c9
        vendor_part_id:                 4119
        hw_ver:                         0x0
        board_id:                       MT_0000000012
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_DOWN (1)
                        max_mtu:                4096 (5)
                        active_mtu:             1024 (3)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet

hca_id: mlx5_1
        transport:                      InfiniBand (0)
        fw_ver:                         16.34.1002
        node_guid:                      1070:fd03:001e:21a7
        sys_image_guid:                 1070:fd03:001e:21a6
        vendor_id:                      0x02c9
        vendor_part_id:                 4119
        hw_ver:                         0x0
        board_id:                       MT_0000000012
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                4096 (5)
                        active_mtu:             1024 (3)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet

hca_id: mlx5_2
        transport:                      InfiniBand (0)
        fw_ver:                         20.34.1002
        node_guid:                      e8eb:d303:00d6:3630
        sys_image_guid:                 e8eb:d303:00d6:3630
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand

hca_id: mlx5_3
        transport:                      InfiniBand (0)
        fw_ver:                         20.34.1002
        node_guid:                      e8eb:d303:00d6:3631
        sys_image_guid:                 e8eb:d303:00d6:3630
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand
```


```
(base) root@dust:/etc/netplan# ibhosts -C mlx5_2
Ca      : 0xe8ebd303000b2f90 ports 1 "evans HCA-1"
Ca      : 0xe8ebd30300d63630 ports 1 "dust HCA-3"

(base) root@dust:/etc/netplan# ibhosts -C mlx5_3
Ca      : 0xe8ebd303000b1751 ports 1 "craig HCA-2"
Ca      : 0xe8ebd30300d63631 ports 1 "dust HCA-4"

```

```
(base) root@dust:/etc/netplan# ibv_devices
    device                 node GUID
    ------              ----------------
    mlx5_0              1070fd03001e21a6
    mlx5_1              1070fd03001e21a7
    mlx5_2              e8ebd30300d63630
    mlx5_3              e8ebd30300d63631
```
### Netplan
```
k6vu@neil:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp150s0f0:
      dhcp4: true
    enp150s0f1:
      dhcp4: true
    enp151s0f0:
      dhcp4: true
    enp151s0f1:
      dhcp4: true
    enp5s0f0:
      dhcp4: true
    enp5s0f1np1:
      addresses:
      - 192.31.21.127/24
      gateway4: 192.31.21.1
      nameservers:
        addresses:
        - 132.249.20.25
        - 198.202.75.26
        search: []
    enxb03af2b6059f:
      dhcp4: true
    enp12s0f0np0:
      addresses:
      - 10.0.1.1/24
      routes:
      - to: 10.0.1.3
        via: 10.0.1.1
    enp12s0f1np1:
      addresses:
      - 10.0.1.2/24
      routes:
      - to: 10.0.1.6
        via: 10.0.1.2
  version: 2
```
## Evans
```
hca_id: mlx5_0
        transport:                      InfiniBand (0)
        fw_ver:                         20.31.1014
        node_guid:                      e8eb:d303:000b:2f90
        sys_image_guid:                 e8eb:d303:000b:2f90
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand

hca_id: mlx5_1
        transport:                      InfiniBand (0)
        fw_ver:                         20.31.1014
        node_guid:                      e8eb:d303:000b:2f91
        sys_image_guid:                 e8eb:d303:000b:2f90
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand
```

```
root@evans:/etc/netplan# ibhosts -C mlx5_0
Ca      : 0xe8ebd30300d63630 ports 1 "dust HCA-3"
Ca      : 0xe8ebd303000b2f90 ports 1 "evans HCA-1"

root@evans:/etc/netplan# ibhosts -C mlx5_1
Ca      : 0xe8ebd303000b1750 ports 1 "craig HCA-1"
Ca      : 0xe8ebd303000b2f91 ports 1 "evans HCA-2"
```

```
root@evans:/etc/netplan# ibv_devices
    device                 node GUID
    ------              ----------------
    mlx5_0              e8ebd303000b2f90
    mlx5_1              e8ebd303000b2f91
```
### Netplan
```
k6vu@evans:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
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
## Craig
```
ca_id: mlx5_0
        transport:                      InfiniBand (0)
        fw_ver:                         20.31.1014
        node_guid:                      e8eb:d303:000b:1750
        sys_image_guid:                 e8eb:d303:000b:1750
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand

hca_id: mlx5_1
        transport:                      InfiniBand (0)
        fw_ver:                         20.31.1014
        node_guid:                      e8eb:d303:000b:1751
        sys_image_guid:                 e8eb:d303:000b:1750
        vendor_id:                      0x02c9
        vendor_part_id:                 4123
        hw_ver:                         0x0
        board_id:                       MT_0000000225
        phys_port_cnt:                  1
                port:   1
                        state:                  PORT_INIT (2)
                        max_mtu:                4096 (5)
                        active_mtu:             4096 (5)
                        sm_lid:                 0
                        port_lid:               65535
                        port_lmc:               0x00
                        link_layer:             InfiniBand
```

```
root@craig:/etc/netplan# ibhosts -C mlx5_0
Ca      : 0xe8ebd303000b2f91 ports 1 "evans HCA-2"
Ca      : 0xe8ebd303000b1750 ports 1 "craig HCA-1"

root@craig:/etc/netplan# ibhosts -C mlx5_1
Ca      : 0xe8ebd30300d63631 ports 1 "dust HCA-4"
Ca      : 0xe8ebd303000b1751 ports 1 "craig HCA-2"
```

```
root@craig:/etc/netplan# ibv_devices
    device                 node GUID
    ------              ----------------
    mlx5_0              e8ebd303000b1750
    mlx5_1              e8ebd303000b1751
```
### Netplan
```
k6vu@craig:~$ cat /etc/netplan/00-installer-config.yaml
# This is the network config written by 'subiquity'
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
