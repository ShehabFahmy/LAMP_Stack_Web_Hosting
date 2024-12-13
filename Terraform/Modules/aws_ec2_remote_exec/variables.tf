variable "aws-linux-instance-ami" {
  type = string
}

variable "instance-type" {
  type = string
}

variable "key-name" {
  type = string
}

variable "subnet-id" {
  type = string
}

variable "secgrp-id" {
  type = string
}

variable "is-public" {
  type = bool
}

variable "ssh-user" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "remote-exec-inline" {
  type = string
}

variable "private-key-path" {
  type = string
}
