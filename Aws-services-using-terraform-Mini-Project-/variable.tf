variable "ami1" {
  type = string


}
variable "s_Name" {
  type        = string
  description = "name of security group"

}
variable "port1" {
  type        = string
  description = "pass the  port numbers"
}
variable "port" {
  type        = string
  description = "pass the  port numbers"
}
variable "protocol1" {
  type        = string
  description = "pass the value of protocol"

}
variable "bucket_name" {
  type        = string
  description = "pass the name of the bucket"

}
variable "tag" {
  type        = map(any)
  description = "pass the value of tags"

}
variable "av-zone" {
  type        = string
  description = "pass the availability zone name"

}
variable "cidr_block" {
  type = string

}
variable "instance_tenancy" {
  type = string

}
variable "av-zone2" {
  type = string

}
variable "route_cidr" {
  type = string

}
variable "ami_name" {
  type = string

}