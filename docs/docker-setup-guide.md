# Docker Setup Guide for EC2 Instances

This guide covers installing Docker, Docker Compose, and related tools on EC2 instances.

## Table of Contents
- [Installing Docker](#installing-docker)
- [Installing Docker Compose](#installing-docker-compose)
- [Installing Make Command](#installing-make-command)
- [Docker Compose Restart Policies](#docker-compose-restart-policies)

---

## Installing Docker

### For Amazon Linux 2 or Amazon Linux 2023

```bash
# Update the package manager
sudo yum update -y

# Install Docker
sudo yum install docker -y

# Start Docker service
sudo systemctl start docker

# Enable Docker to start on boot
sudo systemctl enable docker

# Add ec2-user to docker group (so you don't need sudo)
sudo usermod -a -G docker ec2-user

# Log out and back in for group changes to take effect, or run:
newgrp docker

# Verify installation
docker --version
docker run hello-world
```

### For Ubuntu-based EC2 instances

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install ca-certificates curl gnupg -y

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add your user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker run hello-world
```

### Important Notes
- Make sure your EC2 security group allows the necessary ports if you plan to expose Docker containers
- The `usermod` command allows running Docker without `sudo`, but requires logging out and back in to take effect
- For production use, consider using Docker Compose for multi-container applications

---

## Installing Docker Compose

### Method 1: Docker Compose Plugin (Recommended - Modern)

If you installed Docker using the Ubuntu method above, Docker Compose plugin is already included. You can use it with:

```bash
docker compose version
```

### Method 2: Standalone Docker Compose (Traditional)

For Amazon Linux 2 or if you need the standalone version:

```bash
# Download the latest version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Apply executable permissions
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### Method 3: Install via pip (Alternative)

```bash
# Install pip if not already installed
sudo yum install python3-pip -y  # For Amazon Linux
# OR
sudo apt-get install python3-pip -y  # For Ubuntu

# Install Docker Compose
sudo pip3 install docker-compose

# Verify installation
docker-compose --version
```

### Usage Difference
- **Plugin**: `docker compose up` (space, no hyphen)
- **Standalone**: `docker-compose up` (hyphen)

### Quick Test

Create a simple `docker-compose.yml` file to test:

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
```

Then run:
```bash
docker compose up -d  # Plugin
# OR
docker-compose up -d  # Standalone
```

---

## Installing Make Command

### For Amazon Linux 2 or Amazon Linux 2023

```bash
# Install make
sudo yum install make -y

# Verify installation
make --version
```

### For Ubuntu/Debian-based systems

```bash
# Install make
sudo apt-get update
sudo apt-get install make -y

# Verify installation
make --version
```

### Install Build Tools (Recommended)

Often you'll need `make` along with other build tools like `gcc`, `g++`, etc. It's common to install them as a group:

#### Amazon Linux
```bash
# Install development tools group (includes make, gcc, g++, etc.)
sudo yum groupinstall "Development Tools" -y
```

#### Ubuntu/Debian
```bash
# Install build-essential package (includes make, gcc, g++, etc.)
sudo apt-get install build-essential -y
```

---

## Docker Compose Restart Policies

### Always Restart

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
    restart: always
```

### All Restart Policies

```yaml
version: '3'
services:
  app:
    image: myapp
    restart: always           # Always restart, even after reboot

  database:
    image: postgres
    restart: unless-stopped   # Always restart unless manually stopped

  worker:
    image: worker
    restart: on-failure       # Only restart if container exits with error

  temp:
    image: temp-job
    restart: "no"             # Never restart (default)
```

### Restart Policy Options

- **`always`**: Always restart the container regardless of exit status. Will restart even after system reboot.
- **`unless-stopped`**: Similar to always, but won't restart if the container was manually stopped.
- **`on-failure`**: Only restart if the container exits with a non-zero exit code.
- **`on-failure:3`**: Restart on failure, but limit to 3 restart attempts.
- **`no`**: Never restart automatically (default behavior).

### Example with Multiple Services

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - "80:80"
    restart: always

  app:
    image: myapp
    depends_on:
      - db
    restart: always

  db:
    image: postgres
    volumes:
      - db_data:/var/lib/postgresql/data
    restart: always

volumes:
  db_data:
```

**Note**: The `restart: always` policy is most commonly used for production services that should stay running at all times.
