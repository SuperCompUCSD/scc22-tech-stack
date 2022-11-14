# Testing results on RAID0

Command to test performance:

`date && sudo dd if=/dev/zero of=/dev/md1 bs=1MB count=30000 status=progress && date && sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches' && date`

Make count number of disks times 10000.

## HDD

- 14 HDDs RAID0: 370 MB/s
- 7 HDDs RAID0: 275 MB/s
- 1 HDD: 60 MB/s

## SSD

- 3 SSDs RAID0: 468 MB/s
- 2 SSD of the same type RAID0: 379 MB/s
- 1 SSD: 223, 237, 265 MB/s

## BeeGFS

- 2 SSD: ~750 MB/s
- 1 SSD: ~660 MB/s
