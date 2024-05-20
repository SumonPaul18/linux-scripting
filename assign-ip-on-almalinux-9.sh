#!/bin/bash

# Creates a backup
#cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak_`date +%Y%m%d%H%M`

#Enable PowerTools/CRB repository

dnf install dnf-plugins-core -y
dnf config-manager --set-enabled crb -y
dnf install epel-release -y
sudo dnf install https://www.rdoproject.org/repos/rdo-release.el9.rpm -y
dnf install centos-release-openstack-antelope -y

yum clean all

yum install network-scripts -y

ls /etc/sysconfig/network-scripts/

systemctl status network
systemctl start network
systemctl enable network

systemctl restart network

# Verifying IP & MAC Addresses
ip a

read -p "Type static IP Interface Name: " STATIC_INTERFACE
read -p "Type MAC for static Interface: " MAC_Address
read -p "Type static IP Address with CIDR: " IP_ADDRESS
read -p "Type Gateway4: " GATEWAY
read -p "Type DNS: " DNS

cat <<EOF | sudo tee /etc/sysconfig/network-scripts/ifcfg-$STATIC_INTERFACE
HWADRR=$MAC_Address
NM_CONTROLLED=no
BOOTPROTO=static
ONBOOT=yes
IPADDR=$IP_ADDRESS
PREFIX=24
GATEWAY=$GATEWAY
DNS1=$DNS
#DNS2=8.8.4.4
DEVICE=$STATIC_INTERFACE

EOF

# Apply the Netplan configuration
nmcli connection up $STATIC_INTERFACE

ip a s $STATIC_INTERFACE

systemctl restart NetworkManager

