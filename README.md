# WordPress Docker Ansible Setup

## Overview

This project automates the deployment of a **WordPress** website with a **MySQL** database using **Ansible** and **Docker**. The setup is portable and can be used across various environments (e.g., AWS, local servers, or any cloud platform). This solution includes setting up Docker, Docker Compose, WordPress, and MySQL as containers.

---

```
wordpress-docker-ansible/
├── ansible.cfg          # Ansible configuration file
├── inventory.ini        # Hosts inventory file
├── playbook.yml         # Main playbook to execute
├── roles/
│   ├── docker-host/     
│   │   ├── tasks/        
│   │   │   └── main.yml  # Main tasks for Docker and Docker Compose setup
│   │   ├── templates/    
│   │   │   └── docker-compose.yml.j2  # Docker Compose template for WordPress, MySQL, and phpMyAdmin
│   │   └── defaults/     
│   │       └── main.yml  # Default variables for Docker host setup

```

## Prerequisites

### 1. **Ansible**
Ensure that **Ansible** is installed on your local machine:

```bash
sudo apt update && sudo apt install ansible -y
```


### 1. **Docker & Docker Compose on Target Host**
This playbook installs Docker and Docker Compose if they are not already present on the target server.

### 2. **AWS EC2 Instance (or any other Linux server)**
The playbook assumes you are deploying on a Linux server (e.g., Amazon Linux 2, Ubuntu). Ensure that the security group of your instance allows:

- **Port 22 (SSH)**
- **Port 80 (HTTP)**
- **Port 8081 (phpMyAdmin)**

You must be able to connect to the server via SSH.

### 3. **SSH Key Configuration**
Add your private key path for SSH in the `ansible.cfg` file.

---

## Setup Instructions

### 1. **Clone the Repository:**

```bash
git clone https://github.com/your-repo/wordpress-docker-ansible.git
cd wordpress-docker-ansible
```
### 2. Install Python Dependencies:
Create a virtual environment (optional but recommended) and install the required dependencies:

```bash
python -m venv venv
source venv/bin/activate
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
Execute the playbook to deploy WordPress and MySQL with Docker:

```bash
ansible-playbook playbook.yml
```

## How it Works

### Docker Host Role:
The `docker-host` role installs Docker and Docker Compose on the target host. It then sets up the required Docker Compose file for running WordPress, MySQL, and phpMyAdmin containers.

- MySQL Container (db):
Configures the MySQL container using environment variables for the database name, user, password, and root password.
Data is persisted using the db_data volume.

- WordPress Container (wordpress):
Links to the MySQL container and uses the WORDPRESS_DB_HOST, WORDPRESS_DB_USER, and WORDPRESS_DB_PASSWORD environment variables.
Exposes the WordPress site on port 8000 of the host machine.

- phpMyAdmin Container (phpmyadmin):
Connects to the MySQL container using the PMA_HOST and MYSQL_ROOT_PASSWORD environment variables.
Accessible on port 8081 of the host machine for database management.
---

## Variables

### MySQL Variables (`roles/Docker-host/defaults/main.yml`)
You can modify the following variables for MySQL:

```yaml
mysql_root_password: rootpassword        # Set the MySQL root password
mysql_database: wordpress                # The database name for WordPress
mysql_user: wordpress                    # MySQL user for WordPress
mysql_password: wordpresspassword        # MySQL password for WordPress user
```

## Access WordPress
Once the playbook completes successfully, you can access WordPress by navigating to:

```bash
WordPress: http://<your-server-ip>:8000
phpMyAdmin: http://<your-server-ip>:8081
```

## Troubleshooting

- **Docker Not Running:** Make sure Docker is installed and running by checking with `docker --version` or `docker ps`.

- **Permission Errors:** Ensure that your user has the necessary permissions to use Docker. You might need to add your user to the `docker` group:

  ```bash
  sudo usermod -aG docker $USER ```

- **MySQL Connection Issues:**  If WordPress cannot connect to MySQL, verify that the MySQL container is running and properly linked.