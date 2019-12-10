// Sub-modules
module "security" {
  source         = "./../security"
  allow_ssh      = var.allow_ssh
  ssh_cidr_block = var.ssh_cidr_block
  project_name   = var.project_name
  project_owner  = var.project_owner
}

module "cloudwatch" {
  source       = "./../cloudwatch"
  project_name = var.project_name
}

module "iam" {
  source           = "./../iam"
  cw_log_group_arn = module.cloudwatch.cw_log_group_arn
  project_name     = var.project_name
}

// NodeJS instance resource
resource "aws_instance" "nodejs_instance" {
  ami           = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name    = var.instance_name
    Project = var.project_name
    Owner   = var.project_owner
  }

  vpc_security_group_ids = [module.security.security_group_id]
  iam_instance_profile   = module.iam.instance_profile_name

  user_data = templatefile("${path.module}/userdata.sh", {
    aws_region     = data.aws_region.current.name
    log_group_name = module.cloudwatch.cw_log_group_name
  })
}
