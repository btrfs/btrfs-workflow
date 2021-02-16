#!/bin/bash

if [ "$#" -ne 2 ]; then
        echo "Usage: setup-lvm-fstests.sh <directory> <device>"
        exit 1
fi

XFSTESTS=$1
DEVICE=$2

mkdir /mnt/test > /dev/null 2>&1
mkdir /mnt/scratch > /dev/null 2>&1

pvcreate -ff $DEVICE
vgcreate -f vg0 $DEVICE
for i in $(seq 0 10)
do
        lvcreate -L 10g -n lv$i vg0
done

SCRATCH_MNT=/mnt/scratch
SCRATCH_DEV_POOL=
TEST_DIR=/mnt/test
TEST_DEV=/dev/mapper/vg0-lv0

mkfs.btrfs -f $TEST_DEV

for i in $(seq 1 9)
do
        SCRATCH_DEV_POOL="/dev/mapper/vg0-lv$i $SCRATCH_DEV_POOL"
done
LOGWRITES_DEV="/dev/mapper/vg0-lv10"
PERF_CONFIGNAME="btrfs"

echo "TEST_DIR=$TEST_DIR" > $XFSTESTS/local.config
echo "TEST_DEV=$TEST_DEV" >> $XFSTESTS/local.config
echo "SCRATCH_DEV_POOL=\"$SCRATCH_DEV_POOL\"" >> $XFSTESTS/local.config
echo "SCRATCH_MNT=$SCRATCH_MNT" >> $XFSTESTS/local.config
echo "LOGWRITES_DEV=$LOGWRITES_DEV" >> $XFSTESTS/local.config
echo "PERF_CONFIGNAME=$PERF_CONFIGNAME" >> $XFSTESTS/local.config
echo "MKFS_OPTIONS=\"-K\"" >> $XFSTESTS/local.config
