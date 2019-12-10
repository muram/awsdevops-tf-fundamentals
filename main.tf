// AWS provider configuration
provider "aws" {
  region                  = var.aws_region_1
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.aws_profile_1
}

provider "aws" {
  alias                   = "region_2"
  region                  = var.aws_region_2
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.aws_profile_2
}

// Generate some random results for instance module
resource "random_string" "random_1" {
  length  = 8
  special = false
}

resource "random_string" "random_2" {
  length  = 8
  special = false
}

// Modules
module "nodejs_instance_1" {
  source         = "./modules/instance"
  instance_name  = "${var.project_name}-nodejs-${random_string.random_1.result}"
  key_name       = var.key_name
  instance_type  = var.instance_type
  allow_ssh      = var.allow_ssh
  ssh_cidr_block = var.ssh_cidr_block
  project_name   = var.project_name
  project_owner  = var.project_owner
}

module "nodejs_instance_2" {
  source = "./modules/instance"
  providers = {
    aws = aws.region_2
  }
  instance_name  = "${var.project_name}-nodejs-${random_string.random_2.result}"
  key_name       = var.key_name
  instance_type  = var.instance_type
  allow_ssh      = var.allow_ssh
  ssh_cidr_block = var.ssh_cidr_block
  project_name   = var.project_name
  project_owner  = var.project_owner
}

// Variables
variable aws_region_1 {
  description = "AWS target region 1"
  type        = string
}

variable aws_region_2 {
  description = "AWS target region 2"
  type        = string
}

variable shared_credentials_file {
  description = "Local path for the AWS credentials file"
  type        = string
}

variable aws_profile_1 {
  description = "AWS target profile 1"
  type        = string
}

variable aws_profile_2 {
  description = "AWS target profile 2"
  type        = string
}

variable key_name {
}

variable project_name {
}

variable project_owner {
}

variable instance_type {
}

variable allow_ssh {
}

variable "ssh_cidr_block" {
}

// Outputs
output instance_1_id {
  value = module.nodejs_instance_1.instance_id
}

output instance_1_public_ipv4 {
  value = module.nodejs_instance_1.instance_public_ipv4
}

output instance_1_public_dns {
  value = module.nodejs_instance_1.instance_public_dns
}

output instance_2_id {
  value = module.nodejs_instance_2.instance_id
}

output instance_2_public_ipv4 {
  value = module.nodejs_instance_2.instance_public_ipv4
}

output instance_2_public_dns {
  value = module.nodejs_instance_2.instance_public_dns
}
