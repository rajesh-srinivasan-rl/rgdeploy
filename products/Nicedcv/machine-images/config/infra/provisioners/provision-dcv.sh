#!/bin/bash
#cd /home/ec2-user
p=$(pwd)
echo "You are currently in: $p"
sudo yum update -y
sudo yum install -y jq git gcc-c++ make curl awscli unzip
# import the NICE GPG key. 
#sudo rpm --import https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY
# Download the packages from the NICE DCV download website.
#wget https://d1uj6qtbmh3dt5.cloudfront.net/2023.0/Servers/nice-dcv-2023.0-14852-el7-x86_64.tgz
# Extract the contents of the .tgz archive and navigate into the extracted directory.
#tar -xvzf nice-dcv-2023.0-14852-el7-x86_64.tgz && cd nice-dcv-2023.0-14852-el7-x86_64
# Install the NICE DCV server.
#sudo yum install -y nice-dcv-server-2023.0.14852-1.el7.x86_64.rpm
# To use the web client with NICE DCV version 2021.2 and later, install the nice-dcv-web-viewer package.
#sudo yum install -y nice-dcv-web-viewer-2023.0.14852-1.el7.x86_64.rpm
# To use virtual sessions, install the nice-xdcv package.
#sudo yum install -y nice-xdcv-2023.0.527-1.el7.x86_64.rpm
# If you plan to use GPU sharing, install the nice-dcv-gl package.
#sudo yum install -y nice-dcv-gl-2023.0.1022-1.el7.x86_64.rpm
# install the nice-dcv-simple-external-authenticator package.
#sudo yum install -y nice-dcv-simple-external-authenticator-2023.0.206-1.el7.x86_64.rpm
cd /home/ec2-user

sudo systemctl start dcvserver
sudo systemctl enable dcvserver


sudo crontab -l 2>/dev/null > "/tmp/crontab"
sudo echo '@reboot systemctl restart dcvserver' >> "/tmp/crontab"

# install docker

sudo yum install -y docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

sudo docker pull relevancelab/nice-dcv-auth-svc:1.0.0
sudo docker pull relevancelab/jupiterlab_3.5.0:1.0.3
sudo docker pull relevancelab/rstudio_4.2.1:1.0.3

sudo pip3 install supervisor crudini

# install gtk

sudo yum update -y
sudo yum install -y gtk3-devel
sudo pkg-config --modversion gtk+-3.0
sudo yum install -y gtk-murrine-engine

#steps to install google-chrome on AMI

sudo yum update -y
sudo yum install -y wget curl unzip libX11 GConf2 libXScrnSaver libXss.so.1
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall -y google-chrome-stable_current_x86_64.rpm
#google-chrome-stable

sudo yum update -y
sudo amazon-linux-extras install mate-desktop1.x
sudo bash -c 'echo PREFERRED=/usr/bin/mate-session > /etc/sysconfig/desktop'

sudo wget https://github.com/vinceliuice/Graphite-gtk-theme/archive/refs/heads/main.zip
unzip main.zip
cd Graphite-gtk-theme-main
./install.sh -d /home/ec2-user/.themes --tweaks rimless

cd ..

#steps to install telecor.icons:
#wget https://github.com/vinceliuice/Tela-circle-icon-theme/archive/refs/heads/master.zip
#unzip master.zip
#cd Tela-circle-icon-theme-master
#./install.sh -a -d /home/ec2-user/.icons
#cd ..

#install conda 

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_FILE="Miniconda3-latest-Linux-x86_64.sh"

#
## Download the Miniconda installer
sudo wget "$MINICONDA_URL" -O "$INSTALLER_FILE"

cp /tmp/cluster/* /home/ec2-user/
chmod 777  /home/ec2-user/conda.sh

mkdir -p /home/ec2-user/logos
sudo wget -P /home/ec2-user/logos https://www.rstudio.com/wp-content/uploads/2018/10/black.png
sudo wget -P /home/ec2-user/logos https://jupyter.org/assets/homepage/main-logo.svg


# Define the Miniconda version and installation directory
#MINICONDA_VERSION="latest"
#INSTALL_DIR="/home/ec2-user/miniconda"

# Download the Miniconda installer
#sudo wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh

# Run the Miniconda installer
#sudo bash miniconda.sh -b -p "${INSTALL_DIR}"
#sleep 20
# Add Miniconda to the PATH
#echo "export PATH=\"${INSTALL_DIR}/bin:\$PATH\"" >> /home/ec2-user/.bashrc
#echo 'export PATH="/home/ec2-user/miniconda/bin:$PATH"' >> "/home/ec2-user/.bashrc"



# Activate the changes in the current shell
#sudo export PATH="${INSTALL_DIR}/bin:$PATH"

# Clean up the installer file
rm -rf main.zip nice-dcv-2023.0-14852-el7-x86_64.tgz google-chrome-stable_current_x86_64.rpm 

#sudo shutdown -r +1 "System will reboot in 1 minutes"


#sudo reboot
#sleep 60













