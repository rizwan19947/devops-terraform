#!/bin/bash

# Update package lists
sudo apt update

# Install Ruby
sudo apt install -y ruby-full

# Install wget
sudo apt install -y wget

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install Docker
sudo apt install -y docker.io

# Install Nginx
sudo apt install -y nginx

# Install AWS CodeDeploy Agent
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
