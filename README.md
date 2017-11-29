# Install Kubernetes
This is an ansible script to deploy kubernetes on bare-metal servers. Kubernetes will be installed using kubeadm tool. This means that all kubernetes services will be running in docker containers. This installation includes support for corporate proxys.

## Prerequisites
* This was tested on nodes running CentOS 7.x and Ubuntu 16.04.
* Nodes networking should be configured.
* The nodes can be accessed with the same SSH key.
* Ansible 2.3.

The following should be run on a jumpbox:
~~~
git clone https://github.com/clsacramento/kube-inst
cd kube-inst
~~~

## Files to update with environment configuration
Copy the example files for update
~~~
cp hosts.example hosts
cp ansible.cfg.example ansible.cfg
cp groupvars/all.example groupvars/all
cp groupvars/3par.example groupvars/3par
~~~

 * ./hosts: change ip and host names
 * ./ansible.cfg: change path to ssh_key to connect to all hosts
 * ./groupvars/all: adapt all variables to the environment
 * ./groupvars/3par: add information about 3par connections


## How to deploy Kubernetes:
~~~
ansible-playbook -i hosts deploy.yml
~~~

### Supported networks
The networking plugin can be specified in the ```./groupvars/all``` file.
* Flannel
* Weave
* Calico (needs testing)

### Included addons
The addons can be enabled or disabled individually in the ```./groupvars/all``` file.
* Grafana, Heapster and InfluxDB
* Helm
* Dashboard
* Demo app
* Federation control plane
* Traefik ingress
