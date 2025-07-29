# Semaphore Ansible Controller

A modern web UI for managing Ansible playbooks, deployments, and infrastructure automation. This project provides both **Docker** and **Kubernetes** deployment options for Semaphore UI.

## 📖 Interactive Documentation

**🌟 [View Interactive Documentation](./docs/index.html) 🌟**

For a better reading experience with interactive examples, code highlighting, and visual guides, check out our interactive documentation website.

## 🎯 Overview

**Semaphore UI** is a powerful web interface that makes Ansible management easy and intuitive. Perfect for:
- **DevOps Engineers** learning infrastructure automation
- **Teams** needing a centralized Ansible management platform  
- **Homelab enthusiasts** running automation on Proxmox/K3s clusters
- **Project management** of playbooks, inventories, and deployment tasks

## 🏗️ Project Structure

```
├── docker/                     # Docker deployment
│   ├── docker-compose.yml      # Multi-container setup with MySQL
│   └── setup.sh               # Automated setup script
├── k8s/                       # Kubernetes deployment  
│   ├── postgres-deployment.yaml # PostgreSQL database
│   └── semaphore-deployment.yaml # Semaphore application
└── README.md                  # This documentation
```

## 🚀 Quick Start

### Option 1: Docker Deployment (Recommended for Development)

**Prerequisites:**
- Docker & Docker Compose installed
- Port 3000 available

**Deploy:**
```bash
cd docker/
chmod +x setup.sh
./setup.sh
docker-compose up -d
```

**Access:**
- **URL:** http://localhost:3000
- **Username:** admin
- **Password:** admin123

### Option 2: Kubernetes Deployment (Recommended for Production)

**Prerequisites:**
- Kubernetes cluster (K3s, minikube, etc.)
- kubectl configured
- MetalLB or LoadBalancer support (optional)

**Deploy:**
```bash
cd k8s/

# Create directories on K8s node
mkdir -p /home/k8server/Semaphore_Ansible_Controller/{db-data,semaphore-data}
sudo chown -R 999:999 /home/k8server/Semaphore_Ansible_Controller/db-data/
sudo chown -R 1001:1001 /home/k8server/Semaphore_Ansible_Controller/semaphore-data/

# Deploy PostgreSQL first
kubectl apply -f postgres-deployment.yaml

# Wait for PostgreSQL to be ready
kubectl wait --for=condition=available --timeout=300s deployment/postgres

# Deploy Semaphore
kubectl apply -f semaphore-deployment.yaml
```

**Access:**
- **With LoadBalancer:** http://192.168.1.250:3000
- **With NodePort:** http://[node-ip]:30000
- **Username:** admin
- **Password:** admin123

## 📋 Features

### 🎛️ Web Interface
- **Modern UI** for Ansible management
- **Project organization** with templates and tasks
- **Real-time execution** logs and monitoring
- **User management** and access control
- **Mobile-responsive** design

### 🗄️ Database Support
- **Docker:** MySQL 8.0 with persistent storage
- **Kubernetes:** PostgreSQL 14 with persistent volumes
- **Data persistence** across container restarts

### 🔧 DevOps Integration
- **Git repository** integration for playbooks
- **SSH key management** for target servers
- **Environment variables** and secret management
- **Scheduling** and automation capabilities
- **REST API** for programmatic access

## 🏠 Homelab Integration

### Perfect for K3s Clusters
- **MetalLB LoadBalancer** support for clean IPs
- **Persistent storage** using local volumes
- **Resource-efficient** deployment
- **Easy scaling** and management

### Proxmox VM Management
- Manage your **Proxmox VMs** as Ansible targets
- **Automated deployments** across your homelab
- **Infrastructure as Code** for your environment

## 📁 Data Storage

### Docker Deployment
```
./data/
├── mysql/          # MySQL database files
├── semaphore/      # Semaphore configuration
├── playbooks/      # Your Ansible playbooks
└── ssh-keys/       # SSH keys for target access
```

### Kubernetes Deployment
```
/home/k8server/Semaphore_Ansible_Controller/
├── db-data/        # PostgreSQL database files
└── semaphore-data/ # Semaphore configuration
```

## 🔒 Security Configuration

### Default Credentials
- **Username:** admin
- **Password:** admin123
- **Email:** admin@example.com

### Production Security
1. **Change default passwords** immediately
2. **Enable HTTPS** for production deployments
3. **Configure proper firewall** rules
4. **Use secrets management** for sensitive data
5. **Regular backups** of database and configuration

## 🛠️ Management Commands

### Docker
```bash
# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Update containers
docker-compose pull && docker-compose up -d

# Backup data
tar -czf semaphore-backup-$(date +%Y%m%d).tar.gz data/
```

### Kubernetes
```bash
# Check status
kubectl get pods,svc

# View logs
kubectl logs -f deployment/semaphore
kubectl logs -f deployment/postgres

# Scale deployment
kubectl scale deployment semaphore --replicas=2

# Update deployment
kubectl set image deployment/semaphore semaphore=semaphoreui/semaphore:latest
```

## 📚 Common Use Cases

### 1. **Server Management**
```yaml
# Example playbook: Update all servers
- name: Update servers
  hosts: all
  tasks:
    - name: Update packages
      package:
        name: "*"
        state: latest
```

### 2. **Application Deployment**
```yaml
# Example: Deploy web application
- name: Deploy web app
  hosts: web_servers
  tasks:
    - name: Deploy application
      copy:
        src: "{{ app_source }}"
        dest: /var/www/html/
```

### 3. **Infrastructure Automation**
```yaml
# Example: Configure monitoring
- name: Setup monitoring
  hosts: all
  tasks:
    - name: Install monitoring agent
      package:
        name: node_exporter
        state: present
```

## 🔧 Troubleshooting

### Common Issues

**Docker: Containers won't start**
```bash
# Check logs
docker-compose logs

# Reset and redeploy
docker-compose down -v
./setup.sh
docker-compose up -d
```

**Kubernetes: Pods pending**
```bash
# Check PVC status
kubectl get pvc

# Check node storage
kubectl describe nodes

# Verify directories exist on node
ls -la /home/k8server/Semaphore_Ansible_Controller/
```

**Cannot access web interface**
```bash
# Check service status
kubectl get svc

# Verify LoadBalancer IP
kubectl describe svc semaphore

# Check firewall rules
sudo ufw status
```

**Database connection issues**
```bash
# Check database logs
kubectl logs deployment/postgres
docker-compose logs semaphore-db

# Verify credentials
kubectl get secrets
```

## 🎓 Learning Resources

### DevOps Skills Development
- **Ansible automation** best practices
- **Kubernetes orchestration** patterns
- **Infrastructure as Code** principles
- **CI/CD pipeline** integration
- **Monitoring and observability**

### Next Steps
1. **Create custom playbooks** for your infrastructure
2. **Integrate with Git** repositories
3. **Set up monitoring** with Prometheus/Grafana
4. **Implement backup strategies**
5. **Scale to production** environments


## 🔗 Useful Links

- **📖 [Interactive Documentation](./docs/index.html)** - Enhanced docs with visual guides
- [Semaphore UI Official Documentation](https://docs.semaphoreui.com/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

