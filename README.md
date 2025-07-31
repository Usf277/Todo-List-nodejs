# 🚀 DevOps for ToDo-List-nodejs

This repository delivers a **robust DevOps solution** for the [Todo List Node.js Application](https://github.com/Ankit6098/Todo-List-nodejs), crafted for a DevOps Internship Assessment. It automates the **build**, **deployment**, and **management** processes using modern DevOps tools, ensuring a seamless, scalable, and efficient workflow.

---

## 📁 Project Structure

```plaintext
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions workflow for CI/CD
├── ansible/
│   ├── inventory               # Inventory file with VM IPs
│   ├── playbook.yml            # Ansible playbook for VM configuration
│   └── vault.yml               # Encrypted credentials using Ansible Vault
├── dockerfile                  # Multi-stage Docker build for the app
├── terraform/
│   ├── main.tf                 # AWS infrastructure (EC2, security group, key)
│   └── outputs.tf              # Terraform output configurations
├── docker-compose.yml          # Application + MongoDB setup
├── provision-configure.sh      # Script to provision and configure the server
```

---

## 🧱 Part 1: Dockerization & CI Pipeline

The Node.js application is containerized for consistent environments and integrated into a CI pipeline for automated builds.

- **Description**:
  - Cloned the [Todo-List-nodejs repository](https://github.com/Ankit6098/Todo-List-nodejs).
  - Created a `Dockerfile` with a multi-stage build to containerize the Node.js app, ensuring a lightweight image.
  - Configured `.env` with a custom MongoDB Atlas connection string for database connectivity.
  - Developed `docker-compose.yml` to define two services: `app` (Node.js backend) and `mongodb` (official MongoDB image), linked via an internal Docker network for local testing with `docker-compose up`.
  - Implemented a GitHub Actions workflow (`ci.yml`) triggered on `master` branch pushes, which:
    - Clones the repository.
    - Builds the Docker image from the `Dockerfile`.
    - Authenticates with a private Docker registry using GitHub secrets.
    - Pushes the image tagged as `latest` to the registry.

---

## 🔧 Part 2: Infrastructure & Configuration

Terraform and Ansible automate the provisioning and configuration of the AWS EC2 instance for a reliable infrastructure setup.

- **Description**:
  - Provisioned an AWS EC2 instance using Terraform, including:
    - Configured provider, SSH key pair, security group, and instance resources.
    - Generated an Elastic IP output for dynamic access.
  - Automated EC2 configuration with Ansible playbook (`playbook.yml`):
    - Updated apt packages and installed essential tools (e.g., curl, Docker).
    - Added Docker’s official GPG key and repository, installed Docker Engine, and enabled the Docker service.
    - Added the user to the `docker` group and triggered a reboot to apply changes.
    - Managed secrets securely with Ansible Vault (`vault.yml`).
  - Scripted the full workflow in `provision-configure.sh`:
    - Ran Terraform with auto-approve.
    - Dynamically extracted the EC2 IP and generated an Ansible inventory.
    - Warmed up the SSH connection to bypass host key prompts.
    - Executed the Ansible playbook to configure the EC2 instance.

---

## 🚢 Part 3: Deployment & Continuous Delivery

Docker Compose and a GitHub self-hosted runner enable automated deployment and continuous delivery on the EC2 instance.

- **Description**:
  - Enhanced Terraform configuration:
    - Updated the security group to allow inbound traffic on port 4000 for production access.
    - Increased EC2 t2.micro EBS storage to 16GB from 8GB for improved capacity.
  - Configured `docker-compose.yml` for deployment:
    - Implemented health checks for the Node.js app (HTTP on port 4000) and MongoDB (mongosh ping) to ensure service reliability.
    - Set up to pull the `todo-list-nodejs:latest` image from DockerHub, aligning with the CI pipeline.
  - Used Ansible to automate:
    - Deployment of `docker-compose.yml` and `.env` to the EC2 home directory for consistent setup.
    - Installation of a GitHub self-hosted runner, with secure token storage in `vault.yml` using Ansible Vault.
  - Established continuous deployment with a GitHub self-hosted runner:
    - Integrated with `ci.yml` for a unified CI/CD pipeline.
    - Triggers deployments on `master` branch pushes, pulling the latest image and restarting services with `docker-compose`.
    - Runs on the EC2 instance, optimizing costs and enabling customized workflows.

---

## ✅ Summary

| **Feature**                     | **Tool Used**                     |
|---------------------------------|-----------------------------------|
| 🚀 CI/CD                       | GitHub Actions                    |
| 🐳 Containerization            | Docker                            |
| 📡 Cloud Infrastructure        | AWS (via Terraform)               |
| 🤖 Server Configuration        | Ansible                           |
| 🧬 Deployment Automation       | Docker Compose + Self-hosted Runner |
| 🔐 Secret Management           | Ansible Vault                     |

---

## 📌 Requirements

- AWS Account
- GitHub Repository with configured secrets
- DockerHub or private registry credentials
- SSH key pair for Ansible
- GitHub Runner Token

---

## 📚 Useful Commands

```bash
# 🛠️ Provision and configure the VM
bash provision-configure.sh

# 🔐 Encrypt Ansible Vault
ansible-vault encrypt vault.yml

# 🔓 Decrypt Ansible Vault
ansible-vault decrypt vault.yml

# ▶️ Run Ansible playbook
ansible-playbook -i ansible/inventory ansible/playbook.yml --ask-vault-pass
```

---

## 👨‍💻 Author

**Name**: [Your Name]  
**Role**: DevOps Engineer Intern Candidate  
**Contact**: [your-email@example.com]
