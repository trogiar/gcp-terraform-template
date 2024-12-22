variable "project" {}
variable "env" {}
variable "region" {}
variable "vpc_cidr_range" {
    type = string
    default = "10.0.0.0/16"
}