# DevOps for ToDo-List-nodejs

This repository has been enhanced with a comprehensive DevOps solution to fulfill the requirements of the DevOps Internship Assessment. The project automates the build, deployment, and management of the Todo List Node.js application.

---

### Part 1: Dockerization & CI Pipeline

This part of the solution focuses on containerizing the application and automating the build and push process using a Continuous Integration (CI) pipeline.

#### Dockerization

The Node.js application is dockerized to ensure it can run consistently across different environments.

* **`Dockerfile`**: A multi-stage `Dockerfile` has been created to build an optimized production image. It uses a Node.js base image to install dependencies and build the application, then copies the necessary files into a lightweight `alpine` image to reduce the final image size.

#### CI Pipeline with GitHub Actions

A GitHub Actions workflow is used to create a CI pipeline that automates the building and pushing of the Docker image to a private Docker registry.

* **Workflow Trigger**: The workflow is triggered on a `push` to the `main` branch.
* **Jobs**: The pipeline consists of a single job that performs the following steps:
    1. **Checkout Code**: Clones the repository.
    2. **Login to Docker Registry**: Authenticates with a private Docker registry (e.g., Docker Hub, AWS ECR, etc.) using GitHub Secrets to securely store credentials.
    3. **Build Docker Image**: Builds the Docker image for the Node.js application.
    4. **Push Docker Image**: Pushes the newly built image to the private registry with the appropriate tags (e.g., `latest` and a unique commit SHA tag).

---

### Part 2: Ansible Configuration

Ansible is used to configure a remote Linux VM, ensuring it has all the necessary prerequisites for running the containerized application.

* **VM Setup**: It is assumed that a Linux VM (an EC2 instance on AWS in this case) has been provisioned. The VM's IP address and SSH credentials are configured in an Ansible inventory file.
* **Ansible Playbook (`playbook.yml`)**: This playbook is designed to be run from your local machine to configure the remote VM. It performs the following tasks:
    1. **Install Prerequisites**: Installs necessary packages and dependencies.
    2. **Install Docker**: Installs Docker and Docker Compose on the VM.
    3. **Configure Docker**: Adds the default user to the `docker` group to allow running Docker commands without `sudo`.
    4. **Secure Credentials**: Sensitive information like the Docker registry credentials is managed using Ansible Vault, as indicated by the presence of `vault.yml`. The `provision-configure.sh` script is likely used to handle the vault encryption/decryption and playbook execution.

---

### Part 3: Docker Compose & Continuous Deployment (CD)

This section details the deployment of the application on the VM using Docker Compose and the implementation of a continuous deployment mechanism using a GitHub self-hosted runner.

#### Docker Compose Deployment

The application is deployed on the VM using a `docker-compose.yml` file.

* **Services**: The `docker-compose.yml` defines two services:
    1. **`app`**: The Node.js application container, built from the image pushed in the CI pipeline.
    2. **`mongo`**: A MongoDB container to serve as the database.
* **Persistent Data**: A Docker volume is attached to the MongoDB container to ensure data persistence, even if the container is restarted or removed.
* **Health Checks**: The application service includes a health check to monitor its status, ensuring it's running correctly before marking it as healthy.

#### Continuous Deployment with GitHub Self-hosted Runner

Instead of an external tool, a GitHub self-hosted runner is used on the EC2 instance to handle the continuous deployment part.

* **Justification**: This approach integrates the CD process directly into the GitHub Actions ecosystem. By setting up a self-hosted runner on the EC2 VM, the final deployment step of the workflow can be executed directly on the target machine. This provides a secure and integrated way to pull the latest image and update the running container.
* **Implementation**:
  * A GitHub self-hosted runner is installed and configured on the EC2 VM.
  * The CI/CD workflow is extended with a new job that targets the self-hosted runner.
  * This job is responsible for connecting to the Docker daemon on the VM.
  * It then logs in to the private Docker registry, pulls the latest image, and uses `docker-compose` to restart the application, ensuring the new image is used.
