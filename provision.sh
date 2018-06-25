#!/bin/bash
apt-get update
apt-get install -y docker.io
apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y --allow-unauthenticated kubelet kubeadm kubectl

docker info | grep -i cgroup
cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

sed -i "s/KUBELET_KUBECONFIG_ARGS=/KUBELET_KUBECONFIG_ARGS=--cgroup-driver=cgroupfs /" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload ; systemctl restart kubelet