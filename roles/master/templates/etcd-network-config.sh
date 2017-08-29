#!/bin/bash

if [ -z $1 ] ; then 
	FLANNEL_CIDR=172.30.0.0/16
else 
	FLANNEL_CIDR=$1
fi

keypath={{ etcd_prefix }}/config

key=`etcdctl ls $keypath`

if [ -z $key ] ; then
	etcdctl mk $keypath "{ \"Network\": \"$FLANNEL_CIDR\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"
fi
