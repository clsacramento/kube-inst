# Install Kubernetes

## Prerequisites
* This was tested on nodes running CentOS 7.x and Ubuntu 16.04.
* Nodes networking should be configured.
* The nodes can be accessed with the same SSH key.

The following should be run on the master node or a jumpbox:
~~~
git clone https://github.com/clsacramento/kube-inst
cd kube-inst
~~~

## Files to update with environment configuration

 * Rename ./hosts.example to ./hosts: change ip and host names
 * Rename ./ansible.cfg.example to ./ansible.cfg: change path to ssh_key to connect to all hosts
 * Rename ./groupvars/all.example to ./groupvars/all: adapt all variables to the environment


## How to deploy Kubernetes:
~~~
ansible-playbook -i hosts deploy.yml
~~~

