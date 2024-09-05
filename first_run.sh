#!/bin/bash

mkdir -p git/priv git/others

git clone https://github.com/anba94/workstation-install.git git/priv

sudo dnf install ansible -y

echo "Running Ansible playbook 1..."
ansible-playbook git/priv/workstation-install/ansible/packages.yaml --become

echo "Running Ansible playbook 2..."
ansible-playbook git/priv/workstation-install/ansible/fonts.yaml --become

ansible-playbook git/priv/workstation-install/ansible/flatpaks.yaml --become

# ansible-playbook git/priv/workstation-install/ansible/rice.yaml --become

echo "Script execution completed."
