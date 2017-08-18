# Install Kubernetes

The playbooks are not integrated for a one command installation.

## Files to update with environment configuration

 * hosts: change ip and host names
 * ansible.cfg: change path to ssh_key to connect to all hosts
 * groupvars/all: adapt all variables to the environment



## Steps to install:

### Check if ansible is able to access all hosts:

~~~
ansible-playbook -i hosts test.yml
~~~

Dont continue if this doesnt work, fix it!

### Preconf
This was not testd but should run like this:
~~~
ansible-playbook -i hosts test.yml
~~~
NB: if this does not work just configure the proxy on /etc/yum.conf on all hosts and run yum update

### Install and configure NTP
~~~
ansible-playbook -i hosts ntp.yml
~~~

### Generate an /etc/hosts file and place it on all hosts
~~~
ansible-playbook -i hosts etc-hosts.yml
~~~

### Install kubernetes, etcd and docker packages on all hosts
~~~
ansible-playbook -i hosts kube-install.yml
~~~

### Configure master and kubernetes nodes
~~~
ansible-playbook -i hosts kube-config.yml
~~~

## Quickstart test
~~~
$ kubectl run hello-web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
$ kubectl get pods
~~~

If hte hello-web pod is running, well done.
