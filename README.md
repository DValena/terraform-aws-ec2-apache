Terraform Module to provision EC2 instance with running Apache
Not intended for production use - only for testing purposes

Example of use:

```hcl
provider "aws" {
  region = "eu-west-1"                          #fill your region
}

module "apache" {
  source          = ".//module_ec2_apache"
  vpc_id          = "vpc-0310f492222222222"
  my_ip_with_cidr = "88.103.235.238/32"         #fill your own public ip - because of firewall security group
  key_pair_name   = "myPair01"
  instance_type   = "t2.micro"
  server_name     = "Apache Example Server"
}
```