


apt install ceph-common
modprobe cephfs

# https://documentation.suse.com/es-es/ses/7.1/html/ses-all/admin-caasp-ceph-common-issues.html#solution-7
modprobe rbd

lsmod | grep rbd