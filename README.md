Terraform Module to provision EC2 instance with running Apache
Not intended for production use
It is based upon Andy Brown Terraform certification course:
  https://www.youtube.com/watch?v=V4waklkBC38 

Example of use:

```hcl
provider "aws" {
  region = "eu-west-1"                          #fill your region
}

module "apache" {
  source          = ".//module_ec2_apache"
  vpc_id          = "vpc-0310f492222222222"
  my_ip_with_cidr = "88.103.235.238/32"         #your own public ip - because of firewall to ssh
  key_pair_name   = "myPair01"
  instance_type   = "t2.micro"
  server_name     = "Apache Example Server"
}
```