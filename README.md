This is a note on installing Kubernetes with kubeadm on VirtualBox VMs created by Vagrant.
Vagrant always creates a NAT type network on the first adapter and makes it the default gateway, which creates some extra work if we follow the official instruction on setting up Kubernetes with kubeadm. If we are not using Vagrant to create our VMs, official docs should suffice.
Steps:
1. Use the attached Vagrantfile to create a bunch of Ubuntu 16 VMs. It includes the provision.sh which installs the docker, kubectl, kubelet and kubeadm and sets it up to the state before we can start creating the Kubernetes cluster.
2. Pick one of the VM and use it as a dedicated gateway for other VMs. It will not be among the cluster. For example, we choose the last VM (172.28.148.7) as the gateway.
  * ssh to the gateway, switch to root, run below iptables command to set it up as a gateway:
  ```
  iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
  iptables -A FORWARD -i enp0s3 -o enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -i enp0s8 -o enp0s3 -j ACCEPT
  ```
  Assuming NAT is on enp0s3, host-only network is on enp0s8. Change them accordingly if that's not the case.
3. Shutdown all other VMS, run below virtualbox command on all VMs (except the gateway VM) to remove the first NAT interface:
  ``` vboxmanage modifyvm {vm-name} --nic1 none ```
4. Start up and login to each VM, set default gateway (assume it's 172.28.148.7) and DNS server:
  * Run: ``` route add default gw 172.28.148.7 ```
  * In /etc/resolv.conf, add: ``` nameserver 8.8.8.8 ```
  To test if the gateway is working, try curl google.ca or run apt-get update
5. Now the VMs should be good to deploy Kubernetes with kubeadm, below are steps extracted from the official website. Flannel is used here.
  * On master node, run ``` kubeadm init --pod-network-cidr=10.244.0.0/16 ```
  * After it succeeds, create and folder and copy the kubeconfig file in $HOME/.kube and change its ownership as prompted. Save the kubeadm join command somewhere
  * Install flannel, run ```kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml```
  * In all other VMs, run the previously-generage kubeadm join command. It should work.

