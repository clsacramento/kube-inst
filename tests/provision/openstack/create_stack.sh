source /cfg/rc
openstack stack create -f value -c id --wait -t /cfg/heat.yaml $stackname
