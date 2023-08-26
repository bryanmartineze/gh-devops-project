#Change variables according to yours

variable "default_vpc" {
    type = string
    default = "vpc-0708db8448d3cfb7f"
}

variable "default_subnet" {
    type = string
    default = "subnet-031d0a1b03608593e"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable public_subnet_cidr {
    type = map(any)
    default = {
        a = "10.0.64.0/20"
        b = "10.0.80.0/20"
        c = "10.0.96.0/20"
    }
}

variable private_subnet_cidr {
    type = map(any)
    default = {
        a = "10.0.0.0/20"
        b = "10.0.16.0/20"
        c = "10.0.32.0/20"
    }
}