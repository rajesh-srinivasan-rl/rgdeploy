#!/bin/bash
#
## Define variables for Conda installation
#MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
INSTALLER_FILE="Miniconda3-latest-Linux-x86_64.sh"

#
## Download the Miniconda installer
#sudo wget "$MINICONDA_URL" -O "$INSTALLER_FILE"
#
## Run the installer script
bash "$INSTALLER_FILE" -b -p "/home/ec2-user/miniconda3"
#
## Activate the conda command
source "/home/ec2-user/miniconda3/etc/profile.d/conda.sh"
#
## Update conda
conda update -y conda
#
## Add Conda binaries to PATH
echo 'export PATH="/home/ec2-user/miniconda3/bin:$PATH"' >> "/home/ec2-user/.bashrc"
export PATH="/home/ec2-user/miniconda3/bin:$PATH"
#
## Remove the installer file
rm "$INSTALLER_FILE"
#
## Display Conda version and information
conda --version
#conda info
#sudo shutdown -r +1 "System will reboot in 1 minute, After one minute connect Machine "
echo "Machine will reboot for update environment variable for Conda installation, wait 15 sec and re-connect Machine"
sudo reboot
                        