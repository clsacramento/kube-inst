# Install Kubernetes

The playbooks are not integrated for a one command installation.

These should be run on the master node:
~~~
git clone https://github.com/clsacramento/kube-inst
cd kube-inst
~~~

## Files to update with environment configuration

 * ./hosts: change ip and host names
 * ./ansible.cfg: change path to ssh_key to connect to all hosts
 * ./groupvars/all: adapt all variables to the environment


## Steps to install:

### Check if ansible is able to access all hosts:

~~~
ansible-playbook -i hosts test.yml
~~~

Dont continue if this doesnt work, fix it!

### Preconf
This was not testd but should run like this:
~~~
ansible-playbook -i hosts preconf.yml
~~~
NB: if this does not work just configure the proxy on /etc/yum.conf on all hosts and run yum update

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

If hte hello-web pod is running, well done. Delete it:
~~~
$ kubectl delete deployment hello-web
~~~

## Complimentary configuration

On the master download some yaml to deploy the DNS, the Dashboard and Grafana for monitoring.

~~~
git clone https://bitbucket.org/Dhyaniarun/kubernetes.git
~~~

### Deploy kube-dns first:
~~~
kubectl create -f DNS/skydns-rc.yaml
kubectl create -f DNS/skydns-svc.yaml
~~~

Update the kubelet config to match the new DNS
KUBELET_ARGS="--cluster-dns=10.254.3.100 --cluster-domain=cluster.local"

### Deploy the Dashboard and Grafana

~~~
kubectl create -f Dashboard/dashboard-controller.yaml
kubectl create -f Dashboard/dashboard-service.yaml   
kubectl create -f cluster-monitoring/influxdb
~~~


### Check
~~~
$  kubectl cluster-info
Kubernetes master is running at http://localhost:8080
Heapster is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/heapster
KubeDNS is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-dns
kubernetes-dashboard is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard
Grafana is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/monitoring-grafana
InfluxDB is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/monitoring-influxdb

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
~~~
