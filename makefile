SHELL := /bin/bash

.DEFAULT_GOAL := help

VIRTUALENV ?= "venv-aro"
CONFIGPATH ?= "ansible.cfg"
TEMPFILE ?= "temp_file"

.PHONY: help

help:
	@echo GLHF

virtualenv:	
	rm -rf $(CONFIGPATH)
	ansible-config init --disabled -t all > $(CONFIGPATH)

	awk 'NR==2{print "callbacks_enabled=ansible.posix.profile_tasks"} 1' $(CONFIGPATH) > $(TEMPFILE)

	cat $(TEMPFILE) > $(CONFIGPATH)

	rm $(TEMPFILE)
	
	rm -rf $(VIRTUALENV)
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV) --prompt "ARO Ansible Environment"
	source $(VIRTUALENV)/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install ansible>=2.9.2 && \
	pip3 install -r requirements.txt && \
	pip3 install setuptools && \
	pip3 install ansible-lint && \
	pip3 install junit_xml pymongo xmljson jmespath kubernetes openshift && \
	ansible-galaxy collection install azure.azcollection && \
	ansible-galaxy collection install community.general && \
	ansible-galaxy collection install community.okd && \
	ansible-galaxy collection install ibm.mas_devops && \
	deactivate

deploy-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/bootstrap.yaml

deploy-mas:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ibm.mas_devops.oneclick_core

delete-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/delete-cluster.yaml

recreate-cluster:
	source $(VIRTUALENV)/bin/activate && \
	ansible-playbook ansible/recreate-cluster.yaml

