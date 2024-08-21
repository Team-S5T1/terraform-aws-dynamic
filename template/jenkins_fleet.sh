#!/bin/bash
apt update -y
apt upgrade -y

# Docker 설치
apt install -y docker.io
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
systemctl start docker
systemctl enable docker

#AWS CLI

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

apt install -y unzip
unzip awscliv2.zip 

sudo ./aws/install

# Java 설치
apt install openjdk-21-jdk

EOF


