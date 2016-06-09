Taiga-setup
===========
Creates ec2 instance and security group for it.
Creates rds instance and security group for it.
Creates following configuration:
* Installs a bunch of packages required by taiga systems
* Nginx listening on ports 80 and 443
  * 80 redirects to 443
* Clones taiga-front repository and configures it
* Clones taiga-back repository and configures it

Prerequisities
--------------
* Python >= 2.7
* Virtualenv (sort of optional)
* [Terraform](https://www.terraform.io/downloads.html)
  * Or `brew install terraform`
* Properly configured `~/.aws/credentials`
* Properly configured `./local.tfvars` (see `local.tfvars.template`)
* SSH key to access instances and path to it in `inventory/hosts`
* Properly configured `local.tfvars.temlate` (copy it to `local.tfvars`)


Installation instructions
-------------------------
* Navigate to root of taiga-setup
* Create virtualenv:
  * `virtualenv venv`
* Activate virtualenv:
  * `. venv/bin/activate`
* Install dependencies:
  * `pip install -r requirements.txt`
* Install [terraform-inventory](https://github.com/adammck/terraform-inventory)
  * `go get -u https://github.com/adammck/terraform-inventory`
  * or `brew install terraform-inventory`
* Run terraform: `terraform apply -var-file local.tfvars`
* Run ansible: `ansible-playbook taiga.yml`
