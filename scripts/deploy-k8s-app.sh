#!/bin/bash

# Apply the Kubernetes manifests for WordPress and MySQL
echo "Deploying WordPress..."
kubectl apply -f /home/ec2-user/wordpress-deployment.yaml
kubectl apply -f /home/ec2-user/wordpress-service.yaml

echo "Deploying MySQL..."
kubectl apply -f /home/ec2-user/mysql-deployment.yaml
kubectl apply -f /home/ec2-user/mysql-service.yaml

# Check the status of the pods and services
echo "Checking pods status..."
kubectl get pods

echo "Checking services status..."
kubectl get svc
