#!/bin/bash
sudo yum -y install iptables

# IP 전달 켜기 
echo  "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf 
sudo sysctl -p 

# 개인 IP 라우팅 및 마스킹을 위한 포괄적 규칙 만들기
sudo iptables -t nat -A POSTROUTING -o ens5 -s 0.0.0.0/0 -j MASQUERADE