# Port Guids, ips, & routes
| Node  | HCA ID | GUID             | IP interface | IP          | Dest Route | Dest. Node |
| ----- | ------ | ---------------- | ------------ | ----------- | ---------- | ---------- |
| Neil  | mlx5_2 | e8ebd30300d63630 | ibp12s0f0    | 10.0.1.1/24 | 10.0.1.3   | Evans      |
|       | mlx5_3 | e8ebd30300d63631 | ibp12s0f1    | 10.0.1.2/24 | 10.0.1.6   | Craig      |
| Evans | mlx5_0 | e8ebd303000b1750 | ibp161s0f0   | 10.0.1.3/24 | 10.0.1.1   | Neil       |
|       | mlx5_1 | e8ebd303000b1751 | ibp161s0f1   | 10.0.1.4/24 | 10.0.1.5   | Craig      |
| Craig | mlx5_0 | e8ebd303000b2f90 | ibp129s0f0   | 10.0.1.5/24 | 10.0.1.4   | Evans      |
|       | mlx5_1 | e8ebd303000b2f91 | ibp129s0f1   | 10.0.1.6/24 | 10.0.1.2   | Neil       | 

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
install mellanox firmware tools from `mellanox-firmware-tools-install.sh`

`mst status` to list firmware device path

`mlxconfig -d <firmware path> set LINK_TYPE_P1=<MODE> LINK_TYPE_P2=<MODE>`
 - MODE: 1 - for infiniband mode; 2 - for ethernet
 - LINK_TYPE_P<num>: indicates which interface is being configured

**WILL RENAME INTERFACES**
**REQUIRES A REBOOT FOR CHANGES TO GO INTO EFFECT**

# FDR Switch config
to get serial port access to switch,
minicom -s
 - in serial port setup 
    - serial device: `/dev/ttyUSB0`
    - Bps/Par/Bits: 9600
    - save as serial
 - `sudo minicom serial`
switch login
 - user: `admin`
 - pass: `admin`
have fun <3
for config look at the pdf manual

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

To run pingpong test with neil as server and evans as client:
user@neil:~$ ibv_rc_pingpong -d mlx5_2 -g 4
user@evans:~$ ibv_rc_pingpong -d mlx5_0 -g 3 10.0.1.1
