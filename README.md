# Kubernetes Cluster with WordPress and MySQL

This project automates the setup of a Kubernetes cluster on AWS EC2 instances using Ansible. It also deploys WordPress and MySQL applications on the Kubernetes cluster.

## Setup Instructions

### 1. **Clone the Repository:**

```bash
git clone https://github.com/your-repo/wordpress-docker-ansible.git
cd wordpress-docker-ansible
```
### 2. Install requirements.txt:

```bash
pip install -r requirements.txt
```
### 3. Configure `ansible.cfg` File:
Update the private key path in the `ansible.cfg` file to point to your SSH private key:

```ini
[defaults]
inventory = inventory.ini
remote_user = ec2-user  # Replace with your remote username
host_key_checking = False
private_key_file = ~/.ssh/my-aws-key.pem  # Update with your key file path
```

### Run the Playbook:
Execute the playbook to deploy WordPress and MySQL with k8s:

```bash
ansible-playbook playbook.yml
```

## structure
```
├── ansible/
│   ├── inventory.ini                # Ansible inventory file
│   ├── ansible.cfg                  # Ansible configuration file
│   ├── play.yml                 # Main Ansible playbook
│   ├── roles/
│   │   ├── k8s-cluster/
│   │   │   ├── tasks/
│   │   │   │   ├── main.yml         # Tasks to install Kubernetes, Docker, configure nodes
│   │   │   │   └── setup.yml        # Optional: Additional setup tasks for Kubernetes nodes
│   │   │   ├── files/
│   │   │   │   ├── wordpress-deployment.yaml  # Kubernetes manifest for WordPress Deployment
│   │   │   │   ├── wordpress-service.yaml     # Kubernetes manifest for WordPress Service
│   │   │   │   └── mysql-deployment.yaml      # Kubernetes manifest for MySQL Deployment
├── scripts/
│   ├── init-k8s-cluster.sh          # Script for initializing the Kubernetes cluster
│   └── deploy-k8s-app.sh            # Script for deploying applications to Kubernetes
│
└── README.md                        # Documentation for the project setup and usage
```

## Prerequisites

- Ansible installed on your local machine.
- AWS EC2 instances running Ubuntu (or another supported distribution).
- Kubernetes components (`kubeadm`, `kubelet`, `kubectl`) installed on the nodes.
- SSH access to the EC2 instances with appropriate key pairs.
-  Ensure that the security group of your instance allows:

- **Port 6443: Kubernetes API server**
- **Port 2379-2380: etcd**
- **Port 10250: Kubelet**
- **Ports 30000-32767: NodePort Services**


## Project Structure

+-----------------------------------------------+
|               AWS Infrastructure              |
|   +-----------------+    +------------------+ |
|   | EC2 Instance 1  |    | EC2 Instance 2   | |   
|   | (K8s Master)    |    | (K8s Worker)     | |  
|   +-----------------+    +------------------+ |  
|        |                                       |
|        |                                       |
|        v                                       |
|   +------------------+    +-----------------+ |
|   | Kubernetes Master |    | Kubernetes Node | |
|   | (API Server)      |    | (Worker Node)   | |
|   +------------------+    +-----------------+ |
+-----------------------------------------------+
        |
        v
+-----------------------------------------------+
|               Kubernetes Cluster              |
|   +------------------+   +------------------+ |
|   | WordPress Pod    |   | MySQL Pod        | |
|   +------------------+   +------------------+ |
|        |                           |           |
|        v                           v           |
|   +-----------------+    +-----------------+   |
|   | WordPress Service|    | MySQL Service    |  |
|   +-----------------+    +-----------------+   |
+-----------------------------------------------+
        |
        v
+-----------------------------------------------+
|                External Traffic              |
|   +--------------------------+               |
|   |  Load Balancer (Optional) |               |
|   +--------------------------+               |
|        |                                      |
|        v                                      |
|    External Access to WordPress App         |
+-----------------------------------------------+



## Variables

### MySQL Variables (`roles/k8s-cluster/defaults/main.yml`)
You can modify the following variables for MySQL:

```yaml
mysql_root_password: rootpassword        # Set the MySQL root password
mysql_database: wordpress                # The database name for WordPress
mysql_user: wordpress                    # MySQL user for WordPress
mysql_password: wordpresspassword        # MySQL password for WordPress user
```

## Access the Application
After the playbook completes successfully, you can access the deployed services using the following URLs:

```bash
WordPress: http://<EXTERNAL-IP> 
(which will be appeared automaticle after provisioning ansible you dont need to run ``` kubectl get svc
 ``` )
```



























