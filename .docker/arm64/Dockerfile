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
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#     && mkdir /root/.conda \
#     && bash Miniconda3-latest-Linux-x86_64.sh -b \
#     && rm -f Miniconda3-latest-Linux-x86_64.sh \
#     && echo "Running $(conda --version)" && \
#     conda init bash && \
#     . /root/.bashrc && \
#     conda update conda && \
#     conda create -n python-app && \
#     conda activate python-app && \
#     conda install python=3.6 pip 

# # installing brew & md5sha1sum
# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
# RUN brew install md5sha1sum

# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh \
#     && mkdir /root/.conda \
#     && bash Miniconda3-latest-MacOSX-arm64.sh -b \
#     && rm -f Miniconda3-latest-MacOSX-arm64.sh \
#     && echo "Running $(conda --version)" && \
#     conda init bash && \
#     . /root/.bashrc && \
#     conda update conda && \
#     conda create -n python-app && \
#     conda activate python-app && \
#     conda install python=3.6 pip 



RUN ln -s md5sum /bin/md5
# RUN chmod +x Miniconda3-latest-MacOSX-arm64.sh
# RUN ./Miniconda3-latest-MacOSX-arm64.sh -b -p $HOME/miniconda3 -b
# ENV PATH=/$HOME/miniconda3/bin:$PATH
# RUN conda update -y conda
# RUN rm Miniconda3-latest-MacOSX-arm64.sh

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh \
    && echo "Running $(conda --version)" && \
    conda init bash && \
    . /root/.bashrc && \
    conda update conda && \
    conda create -n python-app && \
    conda activate python-app && \
    conda install python=3.7 pip 
    

# RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
# RUN bash miniconda.sh -b -p $HOME/miniconda
# RUN source "$HOME/miniconda/etc/profile.d/conda.sh"

RUN git clone https://github.com/eqasim-org/ile-de-france.git
COPY ./config/environment.yml /app/ile-de-france/
RUN conda config --set always_yes yes --set changeps1 no
RUN conda update -q conda
RUN conda env create -f ile-de-france/environment.yml

##################################################
# Java setup
##################################################
# https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz
#RUN wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u252b09.tar.gz -O java.tar.gz
#RUN tar xf java.tar.gz
#RUN echo $HOME/jdk8u252-b09/bin >> $GITHUB_PATH
#RUN export PATH=$HOME/jdk8u252-b09/bin:$PATH

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

RUN wget https://github.com/openstreetmap/osmosis/releases/download/0.48.2/osmosis-0.48.2.tgz -O osmosis.tgz
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
