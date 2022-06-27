# UPDATE!

This repository is no longer in use by the Puppet SE Team, and will be official Archived on Friday, July 1st. It will then be deleted on Friday, July 15th. If you are using any of the included code in any way, please take efforts to preserver your access to the code at your earlier convenience.

Thanks!  - The Puppetlabs SE Team

# Terraform Puppet Environment
## AWS Edition

### Description

This terraform code will build a demo environment in AWS containing of:

  - An All-In-One Puppet Master
  - x amount of Linux nodes
  - x amount of Windows nodes

#### Pre-Requisites

* Docker installed on your laptop. https://www.docker.com/get-started
* If you are on a Mac, install Homebrew Package manager https://brew.sh/
* Install ruby: `brew install ruby`
* The ruby hiera-eyaml gem should be installed. `gem install hiera-eyaml`

#### Pre-Deployment Steps

* Run `eyaml createkeys`. 
   * This command wil create a `./keys` folder and generate 2 files in it: *./keys/private_key.pkcs7.pem*, */keys/public_key.pkcs7.pem*.
* Generate private & public SSH key files in the ./keys folder: `ssh-keygen -f ./keys/<your initials>-control-repo`. For example: `ssh-keygen -f ./keys/rr-control-repo` *(just hit Enter to all questions)*
* Upload the <your initials>-control-repo.pub (public) key to your AWS account.
   * Login to the AWS Bastion 
   * Switch role
   * Click on Services -> EC2 -> Key Pair (on left hand side menu)
   * Click on *Import Key Pair* and upload the ./keys/<your initials>-control-repo.pub file or cut-and-paste its contents
* Upload the <your initials>-control-repo.pub key to your Github account
   * Login to Github.
   * Go to your Settings -> SSH and GPG Keys or go to *https://github.com/settings/keys*. 
   * Click on *New SSH Key* button and upload the ./keys/<your initials>-control-repo.pub file.
* Create your Var File(below) or request one from your team. 
  
#### Create Your Var File

**Mandatory Variables**

    aws_sshkey: The name of the sshkey in AWS to use for logging into instances.
    aws_sshkey_path: the path to the PEM file on your laptop.
    user_name: Identify instance you've built (created_by tag)
    prefix: tags a subdomain to your instances.
    pridomain: private domain suffix

**Optional**

    linux_count: Number of CentOS 7 instances to provision. (default: 1)
    windows_count: Number of Windows 2016 instances to provision. (default: 1)
    prefix: Unique prefix for the domain name to match the user's environmental name. (default: "cdrobey")
    git_url: URL of Puppet control repository. (default: "git@github.com:cdrobey/puppet-repo")
    git_pri_key: Path to the primary ssh key of your github repository. (default: "/app/keys/github")
    git_pub_key: Path to the public key of your github repository. (default: "/app/keys/github.pub")
    eyaml_pri_key: Path to the private key used for eyaml hiera. (default: "/app/keys/private_key.pkcs7.pem")
    eyaml_pub_key: Path to the public key use for eyaml heira. (default:  "/app/keys/public_key.pkcs7.pem")


#### Running it in Docker

**Initialize**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light init

**Validate**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light validate --var-file=example.varfile

**Plan**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light plan --var-file=example.varfile

**Apply**

    > docker run -it -e "AWS_ACCESS_KEY_ID=*your-access-key*" -e "AWS_SECRET_ACCESS_KEY=*your-secret-key*" -v $(pwd):/app/ -w /app/ hashicorp/terraform:light apply --var-file=example.varfile



#### Post-Deployment Steps
* Wait for around 5-10 minutes for the PE Console to be available.
* You can ssh to the master and agent nodes by typing: `ssh -i ./keys/<your initials>-control-repo <machine name>`
   * Note that you are using the private key and AWS lets you log into the nodes because you uploaded the corresponding public key with the same name, in the pre-deployment stage.
   * TIP: It is a good idea to put these commands in your `~/.ssh/config` file to stop the host key checking:
      * __UserKnownHostsFile=/dev/null__
      * __StrictHostKeyChecking=no__
   * Reason: You will be destroying & deploying Puppet stacks repeatedly. Terraform code will generate the same node names.However, these are new instance with new SSH host keys. Trying to ssh to the same node name but different host key will cause ssh to report a [WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!](https://linuxcommando.blogspot.com/2008/10/how-to-disable-ssh-host-key-checking.html) error message. 

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
