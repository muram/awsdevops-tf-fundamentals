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
