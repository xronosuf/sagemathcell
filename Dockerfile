# Version: 0.1a2
# SageMathCell
# The ubuntu:trusty Docker image with the SageMathCell.

FROM ubuntu:trusty

MAINTAINER Ruslan Korniichuk <ruslan.korniichuk@gmail.com>

USER root

# Update OS
RUN apt-get update

# Install python, python-dev
RUN apt-get install -y python python-dev

# Install wget
RUN apt-get install -y wget

# Download get-pip.py file
RUN wget https://bootstrap.pypa.io/get-pip.py

# Install pip
RUN python get-pip.py

# Delete get-pip.py file
RUN rm get-pip.py

# Install git
RUN apt-get install -y git

# Install sagecell from GitHub
RUN pip install git+git://github.com/korniichuk/sagecell#egg=sagecell

# Add 'paad' user
RUN useradd -c "PAAD" -m paad

# Setup sudo for cmd exec w/o password
RUN echo "paad ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER paad
WORKDIR /home/paad

# Install SageMathCell
RUN sagecell install
