#!/bin/bash
sudo yum update -y
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
  
sudo yum install docker -y
sudo yum install python3-pip -y
sudo pip3 install docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker ec2-user #optional: ec2-user doesn't need sudo to run docker commands

sudo yum install -y awscli

#aws s3 cp s3://nks3bucket/data/data_be /home/ec2-user/ --recursive

#docker-compose up -d --build

# sudo docker login --username=nkprash --password='Letme!23in'

# sudo docker pull nkprash/nf_capstone_project:be
# sudo docker run nkprash/nf_capstone_project:be -p 5000 5000
# sudo docker container run -d -p 5000:5000 nkprash/nf_capstone_project:be

# sudo docker pull nkprash/nf_capstone_project:db
# sudo docker run nkprash/nf_capstone_project:db

