# eqasim
Exploration of eqasim pipeline

## First very dirty docker version.

Based in the pipeline for IDF a docker version able to run the synthetic dataset has been created. In order to build that docker you need to select 
one of the two compatible architecture `arm64` (Apple Silicon) or `amd64`. 

In order to access to the data, please run:

```
wget "https://drive.switch.ch/index.php/s/Q32FYIHoQeV6pXL/download" -O data.zip
unzip data.zip
rm data.zip
```

### Build docker 

```
docker build -t sdsc-ord/eqasim:latest -f .docker/Dockerfile .       
```

### How run docker interactively.

```
docker run -v {ABSOLUTE_PATH_TO_DATA_FOLDER}:/app/data -it caviri/eqasim_ilf:latest 
```

### How to run the synthetic population generation inside docker. 

```
cd ile-de-france
conda activate ile-de-france
python3 -m synpp
```
