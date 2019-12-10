// Data sources

/* Setup to get the Account ID via data.aws_caller_identity.current.account_id */
data "aws_caller_identity" "current" {}

/* Setup to get the REGION of the provided...provider */
data "aws_region" "current" {}

/*Setup to get the latest Amazon2 AMI */
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
