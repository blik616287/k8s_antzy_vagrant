#!/bin/bash

CODENAME=`lsb_release -cs`

# virtualbox
curl https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > oracle_vbox_2016.gpg
curl https://www.virtualbox.org/download/oracle_vbox.asc | gpg --dearmor > oracle_vbox.gpg
sudo install -o root -g root -m 644 oracle_vbox_2016.gpg /etc/apt/trusted.gpg.d/
sudo install -o root -g root -m 644 oracle_vbox.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian ${CODENAME} contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
sudo apt update
sudo apt install linux-headers-$(uname -r) dkms
sudo apt-get install virtualbox-7.0 -y
sudo /sbin/vboxconfig

# vbox host only network setup
HOSTONLYIF=`VBoxManage hostonlyif create 2>/dev/null | sed 's/^Interface .//g;s/. was.*//g'`
VBoxManage hostonlyif ipconfig "${HOSTONLYIF}" --ip=192.168.57.1 --netmask 255.255.255.0

# vagrant
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vagrant -y

# miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

# make molecule conda env
yes | conda create --prefix ./k8s_conda_env python=3.12
conda activate ./k8s_conda_env
pip install requests==2.31.0 molecule molecule-docker jmespath --use-deprecated=legacy-resolver
ansible-galaxy collection install community.general --force
ansible-galaxy collection install community.docker --force
ansible-galaxy collection install ansible.posix --force
