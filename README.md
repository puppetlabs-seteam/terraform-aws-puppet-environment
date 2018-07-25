# Terraform Puppet Environment
## AWS Edition

### Description

This terraform code will build a demo environment in AWS containing of:

  - An All-In-One Puppet Master
  - x amount of Linux nodes
  - x amount of Windows nodes

#### Pre-Requisites

* Docker installed on your laptop.
* The ruby hiera-eyaml gem should be installed. `gem install hiera-eyaml`

#### Pre-Deployment Steps

* Run `eyaml createkeys`
* Generate ssh keys for github and store them in the ./keys folder eyaml created. `ssh-keygen -f ./keys/control-repo`
* Create [your var file](Create Your Var File).

#### Running it in Docker

**Validate**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light validate

**Plan**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light plan --var-file=example.varfile

**Apply**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light apply --var-file=example.varfile


#### Create Your Var File

**Mandatory Variables**

    aws_sshkey: The name of the sshkey in AWS to use for logging into instances.
    aws_sshkey_path: the path to the PEM file on your laptop.
    user_name: Identify instance you've built (created_by tag)
    git_url: link to your puppet control repo in git.
    prefix: tags a subdomain to your instances.

**Optional**

    linux_count: Number of CentOS 7 instances to provision. (default: 1)
    windows_count: Number of Windows 2016 instances to provision. (default: 1)

####TODO

* Fix the ssh key requirements for both pre-existing or shared keys or create a new one.
* Add options for Ubuntu, Amazon Linux and various other versions / flavors of Linux and Windows.
* Clean up existing code. Still some remnants that no longer apply.
* Make this work out of the box with the default Puppet best-practices control repo.
* Post / Link the terraform code for the VPC / SGs etc... core code.
* Extra Credit: apply ssl certs to the console because I hate the insecure warnings.
* Billing is a thing: create a lambda to stop/start the lab environment.
* Billing is a thing: "office hours" tag to work with the above lambda
* There are still some conflicts in bringing up a bunch of nodes and connecting to a master that has to run a few times to configure itself. Clean it up.
* How to test the environment has completed the build out...maybe a custom report processor?
* Review security groups, pre-build for windows, linux, docker (some high ports for redirection), puppet master
* Billing is a thing: get costs per tagged owner.
* Add discovery, pipelines and the entire puppet product portfolio to the build options.
* Cloud support for Azure and Google.
