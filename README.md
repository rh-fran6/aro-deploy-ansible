# ARO Ansible Environment

This project provides a set of Makefile targets to manage an ARO (Azure Red Hat OpenShift) cluster using Ansible. It includes tasks for creating a virtual environment, configuring Ansible, and running playbooks to deploy and manage the cluster and related resources.

The actual ansible code that this makefile backs can be found in ```ansible``` directory. This implementation assumes:

* The user has a Microsoft Azure account with the right privileges to deploy ARO cluster.
* The user has a RedHat account.
* The user has as existing Azure Key Vault with subscription ID, Cluster Service Principal Cliend ID and Secrets, Azure Tenant ID and RedHat pull secret saved in the key vault.
* User can decide whether to create network resources - VNET, control plane and worker subnets - by updating  ```cluster.conditionals.create_network_vnet_and_subnets``` in the variable file - ```test_var.yaml```.
* User can also modify deployment parameter like whether they are using custom domain, speficifying version or setting specific security settings.
* User must carefully update the test_vars.yaml file to ensure that it meets installation requirements.
* If a cluster.conditional flag is set to false, the value of the parameter specified in the same file will be neglected.
* GitOps will be installed if user set ```gitops.install``` flag to true.
* To install Maximo, user can uncomment the role ```bootstrap.yaml``` file to add the specific installation role.
* User can use any key for the relevant values in key vault, those values need to be updated in test_vars.yaml file.

## Prerequisites

Before using this project, ensure that you have the following installed:

- Python 3
- `pip` (Python package installer)
- `make`
- `oc` (OpenShift CLI)
- `ansible` (version 2.9.2 or higher)

## Usage

### 1. Create Virtual Environment

To create a virtual environment and install the required dependencies, run:

```sh
make virtualenv
```

This command will:

Generate a new ansible.cfg file with disabled options.
Insert the callbacks_enabled=ansible.posix.profile_tasks configuration at the second line of ansible.cfg.
Create a Python virtual environment.
Install necessary Python packages and Ansible Galaxy collections.

### 2. Deploy Cluster

To deploy the ARO cluster using Ansible, run:

```sh
make deploy-cluster
```

This command will activate the virtual environment and run the ansible/bootstrap.yaml playbook.

### 3. Deploy MAS

To deploy MAS (IBM Maximo Application Suite) using Ansible, run:

```sh
make deploy-mas
```

This command will activate the virtual environment and run the ibm.mas_devops.oneclick_core playbook.

### 4. Delete Cluster

To delete the ARO cluster using Ansible, run:

```sh
make delete-cluster
```

This command will activate the virtual environment and run the ansible/delete-cluster.yaml playbook.

### 5. Recreate Cluster

To recreate the ARO cluster using Ansible, run:

```sh
make recreate-cluster
```

This command will activate the virtual environment and run the ansible/recreate-cluster.yaml playbook.

## Makefile Overview

Here is an overview of the Makefile targets and their descriptions:

* `help`: Displays usage information.
* `virtualenv`: Creates a virtual environment, configures Ansible, and installs dependencies.
* `deploy-cluster`: Deploys the ARO cluster using Ansible.
* `deploy-mas`: Deploys MAS using Ansible.
* `delete-cluster`: Deletes the ARO cluster using Ansible.
* `recreate-cluster`: Recreates the ARO cluster using Ansible.

### Configuration
The configuration for Ansible is generated and modified in the virtualenv target. The ansible.cfg file is initialized with all options disabled, and the ```sh callbacks_enabled=ansible.posix.profile_tasks``` option is added to enable task profiling.

### Dependencies
The following dependencies are installed in the virtual environment:

* ansible>=2.9.2
* ansible-lint
* junit_xml
* pymongo
* xmljson
* jmespath
* kubernetes
* openshift
* azure.azcollection
* community.general
* community.okd
* ibm.mas_devops

To install these, just run the virtual environment make command.

### License

This project is licensed under the MIT License. See the LICENSE file for details.

### Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

### Acknowledgments
Special thanks to all contributors and the open-source community for their support and contributions to this project.

