# Use bash shell

## Install these 2 first:
# yum groupinstall "Development Tools"
# dnf install git git-all 

SHELL := /bin/bash

# Default goal to be displayed when no target is specified
.DEFAULT_GOAL := help

# Variables
VIRTUALENV ?= "venv-aro"
CONFIGPATH ?= "ansible.cfg"
TEMPFILE ?= "temp_file"

# Help target
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make virtualenv      - Create a virtual environment and install dependencies"
	@echo "  make create-cluster  - Deploy the cluster using Ansible"
	@echo "  make deploy-mas      - Deploy MAS using Ansible"
	@echo "  make delete-cluster  - Delete the cluster using Ansible"
	@echo "  make recreate-cluster - Recreate the cluster using Ansible"
	@echo "GLHF"

# Target to create virtual environment and configure Ansible
.PHONY: virtualenv
virtualenv:
	# Install Ansible
	sudo dnf install ansible -y
	# Remove old ansible.cfg if it exists
	rm -rf $(CONFIGPATH)
	# Generate a new ansible.cfg file with disabled options
	ansible-config init --disabled -t all > $(CONFIGPATH)
	# Insert the callback configuration at the second line
	awk 'NR==2{print "callbacks_enabled=ansible.posix.profile_tasks"} 1' $(CONFIGPATH) > $(TEMPFILE)
	cat $(TEMPFILE) > $(CONFIGPATH)
	rm $(TEMPFILE)
	# Remove old virtual environment if it exists
	rm -rf $(VIRTUALENV)
	# Create a new virtual environment
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV) --prompt "ARO Ansible Environment"
	# Activate the virtual environment and install dependencies
	source $(VIRTUALENV)/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install 'ansible>=2.9.2' && \
	pip3 install -r requirements.txt && \
	pip3 install setuptools && \
	pip3 install ansible-lint && \
	pip3 install junit_xml pymongo xmljson jmespath kubernetes openshift && \
	ansible-galaxy collection install azure.azcollection && \
	ansible-galaxy collection install community.general && \
	ansible-galaxy collection install community.okd && \
	ansible-galaxy collection install ibm.mas_devops && \
	PYTHONVER=$$(python3 --version | awk '{split($$2, a, "."); print a[1]"."a[2]}') && \
	pip3 install -r venv-aro/lib64/python$${PYTHONVER}/site-packages/ansible_collections/azure/azcollection/requirements.txt && \
	sudo dnf install azure-cli -y && \
	deactivate

# Target to deploy the cluster
.PHONY: deploy-cluster
create-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/create-cluster.yaml

# Target to deploy MAS
.PHONY: deploy-mas
deploy-mas:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ibm.mas_devops.oneclick_core

# Target to delete the cluster
.PHONY: delete-cluster
delete-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/delete-cluster.yaml

# Target to recreate the cluster
.PHONY: recreate-cluster
recreate-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/recreate-cluster.yaml
