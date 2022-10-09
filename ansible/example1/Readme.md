# Using Ansible Terraform Module to Deploy a Terraform Infrastructure

This simple projet is deploying a Docker container by Terraform via the Ansible Terraform module.

### Install

Require Ansible to be installed on the host.

Install the dependency by running

```
make install_requirements
```

### Configuration

The Terraform state file is stored under S3, so it can be configured as

```
make S3_BUCKET=REPLACE_ME S3_KEY=REPLACE_ME S3_REGION=REPLACE_ME init
```

### Tasks

The following tasks are available in this project

- terraform plan - `make plan`
- terraform apply - `make apply`
- terraform destroy - `make destroy`
- test - `make test`

### Todo

Add `Molecule` for role testing
