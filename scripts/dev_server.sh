#!/bin/bash

# Install Python3.9
apt-get update -y && apt-get install -y gcc software-properties-common && add-apt-repository -y ppa:deadsnakes/ppa
apt-get update -y && apt-get install -y python3.9 python3.9-distutils python3.9-venv # python3.9 is required for distutils and venv
apt-get update -y && apt-get install -y python3-apt python3-pip # python3 is required for apt and pip

# Default Python3 to Python3.9
update-alternatives --quiet --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# Upgrade pip
python3 -m pip install --upgrade pip

# Install the Java 11 Runtime
apt-get update -y && apt-get install -y openjdk-11-jre