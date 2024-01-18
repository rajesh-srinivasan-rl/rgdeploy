FROM ubuntu:20.04

# Set the DEBIAN_FRONTEND environment variable to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up user and working directory
RUN useradd -m -s /bin/bash ec2-user && \
    usermod -a -G staff ec2-user && \
    chown -R ec2-user:staff /usr/local
USER ec2-user
WORKDIR /home/ec2-user

COPY requirements.txt /home/ec2-user

# Set default installation directory to /usr/local/bin
ENV PYTHONUSERBASE=/usr/local

# Install JupyterLab and other packages
RUN pip3 install --no-cache-dir -r requirements.txt && \
    rm -rf ~/.cache/pip/*

# # Add JupyterLab to the PATH environment variable
# ENV PATH=/home/ec2-user/.local/bin:$PATH

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]


