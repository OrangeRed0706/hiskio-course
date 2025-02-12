#!/bin/sh
set -e -x -u
export DEBIAN_FRONTEND=noninteractive

#change the source.list
sudo apt-get update
sudo apt-get install -y vim git bash-completion
# Install Docker
export DOCKER_VERSION="5:19.03.5~3-0~ubuntu-bionic"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce=${DOCKER_VERSION}
sudo usermod -aG docker vagrant

#Disable swap
#https://github.com/kubernetes/kubernetes/issues/53533
sudo swapoff -a && sudo sysctl -w vm.swappiness=0
sudo sed '/vagrant--vg-swap/d' -i /etc/fstab

git clone https://github.com/OrangeRed0706/hiskio-course.git

export KUBE_VERSION="1.17.0"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubeadm=${KUBE_VERSION}-00 kubelet=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00

#sudo kubeadm config images pull
#sudo kubeadm init --pod-network-cidr=10.244.0.0/16
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
bash ~/.bash_it/install.sh -s
echo 'source <(kubectl completion bash)' >>~/.bashrc
