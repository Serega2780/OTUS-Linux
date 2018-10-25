#!/bin/bash

clear

echo "Starting RAID creation"
echo

mdadm --create --verbose /dev/md0 -l 10 -n 10 /dev/sd{b,c,d,e,f,g,h,i,j,k}
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f,g,h,i,j,k}
mkdir /etc/mdadm
touch /etc/mdadm/mdadm.conf
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /etc/mdadm/mdadm.conf
parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 10%
parted /dev/md0 mkpart primary ext4 10% 20%
parted /dev/md0 mkpart primary ext4 20% 30%
parted /dev/md0 mkpart primary ext4 30% 40%
parted /dev/md0 mkpart primary ext4 40% 50%
parted /dev/md0 mkpart primary ext4 50% 60%
parted /dev/md0 mkpart primary ext4 60% 70%
parted /dev/md0 mkpart primary ext4 70% 80%
parted /dev/md0 mkpart primary ext4 80% 90%
parted /dev/md0 mkpart primary ext4 90% 100%
for i in $(seq 1 10); do mkfs.ext4 /dev/md0p$i; done
mkdir -p /raid/part{1,2,3,4,5,6,7,8,9,10}
for i in $(seq 1 10); do mount /dev/md0p$i /raid/part$i; done

echo "RAID has been created"
