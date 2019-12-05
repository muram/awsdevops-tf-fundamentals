// Data sources

/* Setup to get the Account ID via data.aws_caller_identity.current.account_id */
data "aws_caller_identity" "current" {}

/* Setup to get the REGION of the provided...provider */
data "aws_region" "current" {}

/*Setup to get the latest Amazon2 AMI */
data "aws_ssm_parameter" "amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

/* IAM policy documents */
data "aws_iam_policy_document" "cw_log_iam_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cw_log_permissions_policy" {
  statement {
    sid    = 1
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]

    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }

  /* For the log streams */
  statement {
    sid    = 2
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = [aws_cloudwatch_log_group.cw_log_group.arn]
  }
}
