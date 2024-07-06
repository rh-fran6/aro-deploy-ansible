SHELL := /bin/bash

.DEFAULT_GOAL := help

VIRTUALENV ?= "venv-aro"

.PHONY: help

help:
	@echo GLHF

virtualenv:
	rm -rf $(VIRTUALENV)
	LC_ALL=en_US.UTF-8 python3 -m venv $(VIRTUALENV) --prompt "ARO Ansible Environment"
	source $(VIRTUALENV)/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install ansible && \
	pip3 install -r requirements.txt && \
	pip3 install setuptools && \
	pip3 install ansible-lint && \
	pip3 install openshift && \
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

