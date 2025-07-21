#!/bin/bash

# Semaphore UI Setup Script
# This script sets up the directory structure and initializes Semaphore

set -e

echo "🚀 Setting up Semaphore UI..."

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p data/mysql
mkdir -p data/semaphore
mkdir -p data/playbooks
mkdir -p data/ssh-keys

# Set proper permissions
echo "🔒 Setting permissions..."
chmod 700 data/ssh-keys
chmod 755 data/playbooks
chmod 755 data/semaphore

# Create a sample ansible.cfg
echo "⚙️  Creating sample ansible.cfg..."
cat > data/playbooks/ansible.cfg << 'EOF'
[defaults]
host_key_checking = False
retry_files_enabled = False
inventory = ./inventory
roles_path = ./roles
remote_user = root

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF

# Create sample inventory
echo "📋 Creating sample inventory..."
cat > data/playbooks/inventory << 'EOF'
[servers]
# Add your servers here
# example: 192.168.1.100 ansible_user=root
# example: server1.local ansible_user=ubuntu ansible_ssh_private_key_file=/root/.ssh/id_rsa

[local]
localhost ansible_connection=local
EOF

# Create sample playbook
echo "📝 Creating sample playbook..."
cat > data/playbooks/hello-world.yml << 'EOF'
---
- name: Hello World Playbook
  hosts: local
  gather_facts: no
  tasks:
    - name: Print hello message
      debug:
        msg: "Hello from Semaphore UI! Deployment successful."

    - name: Show system info
      debug:
        msg: "Running on {{ inventory_hostname }}"
EOF

# Generate SSH key pair if it doesn't exist
if [ ! -f data/ssh-keys/id_rsa ]; then
    echo "🔑 Generating SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f data/ssh-keys/id_rsa -N "" -C "semaphore@localhost"
    echo "📋 Public key created at data/ssh-keys/id_rsa.pub"
    echo "   Copy this to your target servers' authorized_keys file"
fi

echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: docker-compose up -d"
echo "2. Wait for services to start (about 30-60 seconds)"
echo "3. Access Semaphore at: http://localhost:3000"
echo "4. Login with:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📁 All data is stored in the ./data directory"
echo "🔑 SSH keys are in ./data/ssh-keys/"
echo "📚 Place your playbooks in ./data/playbooks/"
echo ""
echo "🔧 To view logs: docker-compose logs -f"
echo "🛑 To stop: docker-compose down"
