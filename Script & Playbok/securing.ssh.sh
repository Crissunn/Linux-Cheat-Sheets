#!/bin/bash
###################################################
#  Author Cristian Gomez
#  Contact: https://www.linkedin.com/in/agcristian/
###################################################

# Functiono to defined colors

function txt_color(){
  NC='\033[0m' # No Color
  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2 ${NC}"
}



# Validate script is being executed with sudo privileges

if [[ $(id -u) -ne 0 ]]; then
  txt_color "red" "This script must be run with sudo privileges."
  exit 1
fi


# Update OS

apt update 

# Install Open-SSH Client and Server

apt install openssh-server openssh-client -y 

# Check if ssh service is active  
# This will return zero code if the service is active if not it willl return non-zero code

if systemctl is-active --quiet ssh; then  
  txt_color "green" "SSH service is already active."
else
  txt_color "red" "SSh not started..."
  txt_color "green" "Starting SSH service..."
  sudo systemctl start ssh
fi


# Validate ssh is enable 

if systemctl is-enabled --quiet ssh; then
  txt_color "green" "SSH service is enabled."
else
  txt_color "red" "SSH service is not enabled..."
  txt_color "green" "Starting SSH service..."
  sudo systemctl enable ssh
fi

# Change port

sed -i 's/#Port 22/Port 2282/g' /etc/ssh/sshd_config

# Validate port has been changed 

if [ $? -eq 0 ]; then
  txt_color "green" "Port successfully changed to 2282"
else
  txt_color "red" "Error: Port change failed"
fi

# Disable root login

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config

# Validate root login was disable 

if [ $? -eq 0 ]; then
  txt_color "green" "root login disable successfully"
else
  txt_color "red" "Error: root login change failed"
fi

# Disable Password Authentication
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config


# Login to specifyc users

read -p "Write user's name: " names

if [ -z "$names" ]; then
  txt_color "red"  "Error: No name entered"
else
  echo "AllowUsers $names" >> /etc/ssh/sshd_config
  txt_color "green"  "User $names added successfully"
fi

# Response time 

sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 300/g' /etc/ssh/sshd_config

# Validate Response time 

if [ $? -eq 0 ]; then
  txt_color "green" "ClientAliveInterval successfully"
else
  txt_color "red" "Error: ClientAliveInterval change failed"
fi

sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 0/g' /etc/ssh/sshd_config

if [ $? -eq 0 ]; then
  txt_color "green" "ClientAliveCountMax successfully"
else
  txt_color "red" "Error: ClientAliveCountMax change failed"
fi


# Change ChallengeResponseAuthentication

echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config


if [ $? -eq 0 ]; then
  txt_color "green" "ChallengeResponseAuthentication successfully"
else
  txt_color "red" "Error: ChallengeResponseAuthentication change failed"
fi


# Apply modifications

systemctl reload ssh


if [ $? -eq 0 ]; then
  txt_color "green" "SSH reload successfully"
else
  txt_color "red" "Error: SSH reload failed"
fi