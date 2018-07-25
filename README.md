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
* RUN IN DOCKER: docker run -it -v $(pwd):/app/ -w /app/ hashicorp/terraform:light plan --var-file=*your-var-file*.varfile

#### Running it in Docker

*Validate*

  > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light validate

  > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light plan --var-file=example.varfile

  > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light apply --var-file=example.varfile


#### Create Your Var File