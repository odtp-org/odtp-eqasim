FROM ubuntu:22.04

##################################################
# Ubuntu setup
##################################################

# Ubuntu setup
RUN apt update && apt install -y \
    python3.10 \
    python3-pip \
    wget \
    unzip \
    nano \
    git \
    g++ \
    gcc \
    htop \
    zip \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

##################################################
# ODTP setup
##################################################

COPY odtp-component-client/requirements.txt /tmp/odtp.requirements.txt
RUN pip install -r /tmp/odtp.requirements.txt

##################################################
# Java setup
##################################################

# Install OpenJDK-11
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless default-jdk && \
    apt-get clean;

##################################################
# Maven setup
##################################################

RUN mkdir /tmp/maven
RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.3/apache-maven-3.6.3-bin.tar.gz -O /tmp/maven.tar.gz
RUN tar xf /tmp/maven.tar.gz -C /tmp/maven 
RUN export PATH=/tmp/apache-maven-3.6.3/bin:$PATH

##################################################
# Osmosis setup
##################################################

RUN mkdir /tmp/osmosis
RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz -O /tmp/osmosis.tgz
RUN tar xf /tmp/osmosis.tgz -C /tmp/osmosis

##################################################
# GDAL Setup
##################################################

RUN apt-get update && \
    apt-get install -y libgdal-dev && \
    apt-get clean;
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

##################################################
# Eqasim setup
##################################################

COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt


##################################################
# ODTP Preparation
##################################################

RUN mkdir /odtp \
    /odtp/odtp-config \
    /odtp/odtp-app \
    /odtp/odtp-component-client \
    /odtp/odtp-logs \ 
    /odtp/odtp-input \
    /odtp/odtp-workdir \
    /odtp/odtp-output 

# This last 2 folders are specific from odtp-eqasim
RUN mkdir /odtp/odtp-workdir/cache \
    /odtp/odtp-workdir/output 

# This copy all the information for running the ODTP component
COPY odtp.yml /odtp/odtp-config/odtp.yml

COPY ./odtp-component-client /odtp/odtp-component-client

COPY ./app /odtp/odtp-app
WORKDIR /odtp

# Fix for end of the line issue on Windows. Avoid error when building on windows
RUN find /odtp -type f -iname "*.sh" -exec sed -i 's/\r$//' {} \;

ENTRYPOINT ["bash", "/odtp/odtp-component-client/startup.sh"]