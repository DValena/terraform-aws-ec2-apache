#!/bin/bash
touch my_hahafile_test
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd