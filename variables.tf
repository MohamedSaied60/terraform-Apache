variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = ""
}

variable "your_name" {
  description = "Your name for the welcome message"
  type        = string
  default     = ""  # Change this to your name
}
variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 0
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = ""
}
