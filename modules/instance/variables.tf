variable key_name {
  description = "Name of an existing EC2 Key Pair in the target deployment region"
  type        = string
}

variable instance_type {
  description = "The type of AWS EC2 instance to launch"
  type        = string
  default     = "t3.micro"
}

variable instance_name {
  description = "Name of the EC2 instance"
  type        = string
}


variable allow_ssh {
  description = "Whether to allow ssh access to the instance or not, false or true"
  type        = bool
  default     = "false"
}

variable ssh_cidr_block {
  description = "The CIDR block of a source IP range to access the instance via SSH"
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
