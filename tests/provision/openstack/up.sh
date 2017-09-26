if [ -z "$1" ] 
then
	name=kubestack
else
	name=$1
fi

rc=/cfg/rc
#stack=`sudo docker run -ti -v $PWD:/cfg --rm clsacramento/pyoscli:v0.3 "source $rc; openstack stack create --wait -t /cfg/heat.yml $kname"`

touch stack.log
echo -n "" > stack.log
sudo docker run --entrypoint="/bin/bash" --env "stackname=$name" --env "RC=$rc" -ti -v $PWD:/cfg --rm clsacramento/pyoscli:v0.3 "/cfg/create_stack.sh" | tee stack.log

if grep -i -q complete stack.log
then
	stackid=`tail -n 1 stack.log | tr -d '\n' | tr -d '\r'`
	echo the stack was created with id: $stackid
else
	echo could not create stack
	exit
fi

stackouput_field=servers_net
touch stackout
echo -n "" > stackout
sudo docker run --entrypoint="/bin/bash" --env "stackid=$stackid" --env "stackouput_field=$stackouput_field" -ti -v $PWD:/cfg --rm clsacramento/pyoscli:v0.3 "/cfg/get_stack_output.sh" | tee stackout
#sudo docker run --entrypoint="/bin/bash" --env "stackid=$stackid" --env "stackouput_field=$stackouput_field" -ti -v $PWD:/cfg --rm clsacramento/pyoscli:v0.3 

serversnames=`cat stackout | jq -r '.[0] | .[]'`
serversips=`cat stackout | jq -r '.[1] | .[]'`

mastername=`echo $serversnames | awk '{ print $1}'`
masterip=`echo $serversips | awk '{ print $1}'`

workersnames=`echo $serversnames | sed "s/$mastername //g"`
workersips=`echo $serversips | sed "s/$masterip //g"`
workerscount=`echo $workersnames | wc -w`

touch hosts
echo -n "" > hosts

echo [local] | tee -a hosts
echo localhost ansible_connection=local | tee -a hosts
echo "" | tee -a hosts
echo [master] | tee -a hosts
echo $mastername ansible_ssh_host=$masterip | tee -a hosts
echo "" | tee -a hosts
echo [kubelets] | tee -a hosts
for i in `seq 1 $workerscount` 
do
	wname=`echo $workersnames | cut -d' ' -f$i`
	wip=`echo $workersips | cut -d' ' -f$i`
	echo "$wname ansible_ssh_host=$wip" | tee -a hosts
done
echo "" | tee -a hosts
echo [kube:children] | tee -a hosts
echo master | tee -a hosts
echo kubelets | tee -a hosts

cd ../../../
ansible-playbook -i tests/provision/openstack/hosts kube-deploy.yml
