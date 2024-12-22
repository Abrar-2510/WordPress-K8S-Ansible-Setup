#!/bin/bash

# Set up the Kubernetes master node
echo "Initializing Kubernetes master node..."
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Set up kubeconfig for the ec2-user
echo "Setting up kubectl for ec2-user..."
sudo mkdir -p /home/ec2-user/.kube
sudo cp /etc/kubernetes/admin.conf /home/ec2-user/.kube/config
sudo chown ec2-user:ec2-user /home/ec2-user/.kube/config

# Install Flannel network plugin
echo "Applying Flannel network plugin..."
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Print instructions for joining worker nodes
echo "Kubernetes master node initialized. Use the following command on worker nodes to join the cluster:"
kubeadm token create --print-join-command
