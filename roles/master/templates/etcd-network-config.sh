#!/bin/bash

if [ -z $1 ] ; then 
	FLANNEL_CIDR={{ flannel_cidr }}
else 
	FLANNEL_CIDR=$1
fi

keypath={{ etcd_prefix }}/config

key=`etcdctl ls $keypath`

if [ -z $key ] ; then
	etcdctl mk $keypath "{ \"Network\": \"$FLANNEL_CIDR\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"
fi
