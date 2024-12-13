variable "secgrp-name" {
  type = string
}

variable "created-by" {
  type = string
}

variable "vpc-id" {
  type = string
}

variable "ingress-data" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = list(string)
  }))
}

variable "egress-data" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
