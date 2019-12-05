// AWS provider configuration
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = var.shared_credentials_file
  profile                 = var.aws_profile
}


// NodeJS instance resource
resource "aws_instance" "nodejs_instance" {
  ami           = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = "t2.micro"
  key_name      = var.key_name
  tags = {
    Name    = "${var.project_name}-nodejs"
    Project = var.project_name
    Owner   = var.project_owner
  }

  vpc_security_group_ids = [aws_security_group.nodejs_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  user_data = templatefile("${path.module}/userdata.sh", {
    aws_region     = data.aws_region.current.name
    log_group_name = aws_cloudwatch_log_group.cw_log_group.name
  })
}


// Instance security group and allow rules resources
resource "aws_security_group" "nodejs_sg" {
  description = "Allow HTTP and SSH Access for NodeJS"
  name_prefix = "${var.project_name}-nodejs-sg"
  tags = {
    Name    = "${var.project_name}-nodejs-sg"
    Project = var.project_name
    Owner   = var.project_owner
  }
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nodejs_sg.id
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.allow_ssh == true ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.ssh_cidr_block}"]
  security_group_id = aws_security_group.nodejs_sg.id
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nodejs_sg.id
}


// CloudWatch logs resource
resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "${var.project_name}-nodejs-logs"
  retention_in_days = 7
}


// IAM resources
resource "aws_iam_role" "cw_log_iam_role" {
  name_prefix        = "${var.project_name}-nodejs-cloudwatch"
  assume_role_policy = data.aws_iam_policy_document.cw_log_iam_trust_policy.json
}

resource "aws_iam_role_policy" "attach_cw_log_iam_policy_to_role" {
  policy = data.aws_iam_policy_document.cw_log_permissions_policy.json
  role   = aws_iam_role.cw_log_iam_role.id
}

resource "aws_iam_instance_profile" "instance_profile" {
  role = aws_iam_role.cw_log_iam_role.name
}

