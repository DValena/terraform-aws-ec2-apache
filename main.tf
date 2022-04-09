data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_security_group" "sg_my_server" {
  name = "sg_my_apache_server"
  description = "My Apache server security group"
  vpc_id = data.aws_vpc.main.id  

  ingress = [
    {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
    },
    {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip_with_cidr]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false  
    }    
  ]

    egress = [
    {
        description = "outgoing trafic"
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false  
    }  
    ]

}


data "aws_key_pair" "deployer" {
  key_name = var.key_pair_name    
}
  /*
  resource "aws_key_pair" "deployer" {
    key_name = "deployer-key"
    public_key = var.public_key  
  }
  */



data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.sh")
  #template = file("${abspath(path.module)}/userdata.yaml") # podle ABrown, me nefunguje
  
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "owner-alias"
    values = ["amazon"]  
  }
  filter {
    name = "name"
    values = ["amzn2-ami-kernel*"]  
  }  
}



data "aws_subnet_ids" "subnets_ids" {
  vpc_id = data.aws_vpc.main.id
}


resource "aws_instance" "my_apache_server" {
  instance_type = var.instance_type
  ami = "${data.aws_ami.amazon-linux-2.id}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  
  #subnet_id = tolist(data.aws_security_group.sg_my_server.id)[0]   #see video ABrown 9:20, if we want external security group, not create it here
  key_name = "${data.aws_key_pair.deployer.key_name}"

  user_data = data.template_file.user_data.rendered
/* bash command are able to write directly not only via external file
  user_data = <<EOF
#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd  
EOF
*/
  tags = {
    Name = var.server_name
  }
}