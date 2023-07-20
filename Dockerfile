FROM ubuntu:latest

RUN apt update
RUN apt install python3 python3-pip -y

##################################################
# Ubuntu setup
##################################################

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends \
    unzip \
    nano \
    git \ 
    g++ \
    gcc \
    htop \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

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

RUN wget https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.3/apache-maven-3.6.3-bin.tar.gz -O maven.tar.gz
RUN tar xf maven.tar.gz
RUN export PATH=$HOME/apache-maven-3.6.3/bin:$PATH

##################################################
# Osmosis setup
##################################################

RUN mkdir /tmp/osmosis
RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz -O /tmp/osmosis.tgz
RUN tar xf /tmp/osmosis.tgz -C /tmp/osmosis

##################################################
# GDAL Setup
##################################################

# Install OpenJDK-11
RUN apt-get update && \
    apt-get install -y libgdal-dev && \
    apt-get clean;

##################################################
# Eqasim setup
##################################################

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

##################################################
# Scenario setup
##################################################

RUN mkdir /app /app/data /app/output /app/cache
WORKDIR /app

RUN git clone ${EQASIM_SCENARIO}

## How to share the config file as user? Maybe placing in volume? 
ENTRYPOINT ["bash"]