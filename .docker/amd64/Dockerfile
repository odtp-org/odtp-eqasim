ARG VERSION_BUILD

#FROM --platform=linux/amd64 ubuntu:latest
FROM ubuntu
ENV PYTHONUNBUFFERED=true
WORKDIR /app


#LABEL org.opencontainers.image.source=https://github.com/caviri/ILF_docker
LABEL org.opencontainers.image.description="ILF pipeline"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.version ${VERSION_BUILD}

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
# Conda setup
##################################################

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "Running $(conda --version)" && \
    conda init bash && \
    . /root/.bashrc && \
    conda update conda && \
    conda create -n python-app && \
    conda activate python-app && \
    conda install python=3.7 pip 
    

RUN git clone https://github.com/eqasim-org/ile-de-france.git
COPY ./config/environment.yml /app/ile-de-france/
RUN conda config --set always_yes yes --set changeps1 no
RUN conda update -q conda
RUN conda env create -f ile-de-france/environment.yml

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

RUN wget http://mirror.easyname.ch/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O maven.tar.gz
RUN tar xf maven.tar.gz
#RUN echo $HOME/apache-maven-3.6.3/bin >> $GITHUB_PATH
RUN export PATH=$HOME/apache-maven-3.6.3/bin:$PATH

##################################################
# Maven setup
##################################################

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.3/osmosis-0.48.3.tgz -O osmosis.tgz
RUN mkdir /app/osmosis
RUN tar xf /app/osmosis.tgz -C /app/osmosis
#RUN echo $HOME/osmosis/bin >> $GITHUB_PATH

##################################################
# Eqasim setup
##################################################

RUN mkdir /app/data
## Generate folder with data and output
RUN mkdir /app/output
RUN mkdir /app/cache
COPY ./config/config.yml /app/ile-de-france/
#RUN wget https://drive.switch.ch/index.php/s/Q32FYIHoQeV6pXL/download
#RUN unzip file.zip
# TODO UNZIP AND PLACE IN DATA FOLDER

##################################################
# Entrypoint setup
##################################################

#COPY ".docker/entrypoint.sh" "/entrypoint.sh"

# Set user
#RUN useradd -ms /bin/bash eqasim_user
#USER eqasim_user

# Test gimie
#RUN gimie --version

# Set command and entrypoint
#CMD ["bash"]
#ENTRYPOINT ["/entrypoint.sh"]


### python3 -m synpp
## SQL not installed
