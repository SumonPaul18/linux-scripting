
# Assign IP Addresses ASK using Shell Script

#### Creates a backup
```
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak_`date +%Y%m%d%H%M`
```
#### Create a Shell Script name `setup-static-ip-ubuntu.sh`
```
nano setup-static-ip-ubuntu.sh
```

```
#!/bin/bash
read -p "Type static IP Interface Name: " STATIC_INTERFACE
read -p "Type DHCP Interface Name: " DHCP_INTERFACE
read -p "Type static IP Address with CIDR: " IP_ADDRESS
read -p "Type Gateway4: " GATEWAY
read -p "Type DNS: " DNS

cat <<EOF | sudo tee /etc/netplan/00-installer-config.yaml
network:
  renderer: networkd
  ethernets:
    $STATIC_INTERFACE:
      dhcp4: no
      addresses:
        - $IP_ADDRESS
      routes: 
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$DNS]
    $DHCP_INTERFACE:
      dhcp4: yes
EOF
```

#### Apply the Netplan configuration
```
sudo netplan apply
```
---

# Assign IP Addresses Pre-Define using Shell Script

#### Creates a backup
```
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak_`date +%Y%m%d%H%M`
```
#### Create a Shell Script name `setup-static-ip-ubuntu.sh`
```
nano setup-static-ip-ubuntu.sh
```

```
#!/bin/bash

STATIC_INTERFACE="enp0s3"  
DHCP_INTERFACE="enp0s8" 

IP_ADDRESS="10.0.2.250"
CIDR="24"
GATEWAY="10.0.2.2"
DNS="8.8.8.8"

cat <<EOF | sudo tee /etc/netplan/00-installer-config.yaml
network:
  renderer: networkd
  ethernets:
    $STATIC_INTERFACE:
      dhcp4: no
      addresses:
        - $IP_ADDRESS/$CIDR
      routes: 
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: [$DNS]
    $DHCP_INTERFACE:
      dhcp4: yes
EOF
```
```
sudo netplan apply
```
---
