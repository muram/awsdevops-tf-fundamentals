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
