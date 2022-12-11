variable "env" {
  type    = string
  default = "terraform"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  default  = [
    { cidr = "10.0.10.0/24" , az = "ap-northeast-2a" },
    { cidr = "10.0.20.0/24" , az = "ap-northeast-2b" },
    { cidr = "10.0.30.0/24" , az = "ap-northeast-2c" }
  ]
}

variable "private_subnets" {
  type = list(object({
    cidr    = string
    az      = string
    use_nat = bool
  }))
  default  = [
    { cidr = "10.0.40.0/24" , az = "ap-northeast-2a" , use_nat = true },
    { cidr = "10.0.50.0/24" , az = "ap-northeast-2b" , use_nat = true },
    { cidr = "10.0.60.0/24" , az = "ap-northeast-2c" , use_nat = true }
  ]
}


variable "tgw_id" {
  description = "TGW ID"
  type        = string
  default     = "tgw-01eb040f6a5e93e1e"
}

variable "add_route" {
  description = "Add TGW Routing"
  type        = list(object({
    dst_cidr     = string
    create_route = bool
  }))
  default     = [
    { dst_cidr = "10.100.0.0/16" , create_route = true },
    { dst_cidr = "192.168.10.0/24" , create_route = true }
  ]
}