variable aws_region {
  description = "AWS target region"
  type        = string
}

variable shared_credentials_file {
  description = "Local path for the AWS credentials file"
  type        = string
}

variable aws_profile {
  description = "AWS target profile"
  type        = string
}

variable key_name {
  description = "Name of an existing EC2 Key Pair in the target deployment region"
  type        = string
}

variable project_name {
  description = "The name of the project for tagging purposes"
  type        = string
}

variable project_owner {
  description = "The name of the project owner for tagging purposes"
  type        = string
}

variable allow_ssh {
  description = "Whether to allow ssh access to the instance or not, false or true"
  type        = bool
  default     = "false"
}

variable "ssh_cidr_block" {
  description = "The CIDR block of a source IP range to access the instance via SSH"
  type        = string
}


