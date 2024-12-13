variable "region" {
  type    = string
  default = "us-east-1"
}

variable "me" {
  type    = string
  default = "Shehab"
}

data "http" "my-public-ip" {
  url = "http://checkip.amazonaws.com"
}

variable "domain-name" {
  type    = string
  default = "shehabfahmy.site"
}

variable "record-name" {
  type    = string
  default = "www.atw-lamp-stack-task.shehabfahmy.site"
}
