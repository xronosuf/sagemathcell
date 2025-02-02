# Name: korniichuk/sagemathcell
# Short Description: SageMathCell
# Full Description: The ubuntu:trusty Docker image with the SageMathCell.
# Version: 0.1b2

FROM ubuntu:trusty

MAINTAINER Ruslan Korniichuk <ruslan.korniichuk@gmail.com>

USER root

# Retrieve new lists of packages
ENV REFRESHED_AT 2015–12–28
RUN apt-get -qq update # -qq -- no output except for errors

# Install python, python-dev

# Install stuff to add a ppa.
RUN apt-get install -y software-properties-common
RUN apt-get update

# Add ppa to get python3
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update

# Install python3.
RUN apt-get install -y python3.6

# Install wget
RUN apt-get install -y wget

# Download get-pip.py file
RUN wget https://bootstrap.pypa.io/get-pip.py

# Install pip
RUN python3.6 get-pip.py

# Delete get-pip.py file
RUN rm get-pip.py

# Install git
RUN apt-get install -y git

# Install sagecell from GitHub
RUN pip install git+git://github.com/korniichuk/sagecell#egg=sagecell
RUN pip install --upgrade sagecell

# Install openssh-server
RUN apt-get install -y openssh-server

# Install socket
RUN apt-get install socket

# Add 'paad' user
RUN useradd -c "PAAD" -m paad

# Setup sudo w/o password for 'paad' user
RUN echo "paad ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Change password for 'paad' user
RUN echo "paad:paad" | chpasswd

USER paad
WORKDIR /home/paad

# Install SageMathCell
RUN sagecell install

# Expose a port
EXPOSE 6363

# Setup SSH for auto login to localhost without a password
RUN ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Copy the 'sagemathcellscript' file to the filesystem of the container
COPY sagemathcellscript sagemathcellscript
RUN sudo chmod 755 sagemathcellscript

# Disable the terms of service requirement
COPY config.py /home/paad/sc_build/sagecell/config.py

CMD ./sagemathcellscript
