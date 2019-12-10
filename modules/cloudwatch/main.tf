// CloudWatch logs resource
resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "${var.project_name}-nodejs-logs"
  retention_in_days = 7
}
