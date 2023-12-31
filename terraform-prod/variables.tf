#Change variables according to yours

variable "default_vpc" {
  type    = string
  default = "vpc-0708db8448d3cfb7f"
}

variable "default_subnet" {
  type    = string
  default = "subnet-031d0a1b03608593e"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "namespaces" {
    type = list(string)
    default = ["trainschedule", "monitoring"]
}
