# ODTP Eqasim Component
ODTP component for running Eqasim. 

## How to run this docker. 

1. Prepare manually a folder called volume containing the following files of our selected scenario:

- data
- config.yml 

2. Run the following command.Select the correct volume folder, the `SCENARIO` you want to simulate (`"IDF"` or `"CH"`) and the MONGODB_CLIENT URL. 

```
docker run -it --rm -v /volume:/odtp/odtp-volume -e SCENARIO=IDF -e MONGODB_CLIENT="mongodb://USER:PASS@10.95.48.38:27017/" caviri/odtp-eqasim:latest
```

# Deprecated documentation

This component contains: 
1. Data loaders
2. Eqasim synthetic population generation
3. Matsim testing

Development phases: 

1. [x] Basic docker container that allows to run IDF scenario
2. [x] Docker container compatible with more than one scenarios
3. [x] ODTP single-component prototype
4. [x] Eqasim division in 3 components:
    - Data loaders
    - Eqasim
    - Matsim


## First docker

Based in the pipeline for IDF a docker version able to run the synthetic dataset has been created. In order to build that docker you need to select 
one of the two compatible architecture `arm64` (Apple Silicon) or `amd64`. 

In order to access to the data, please run:

```
wget "https://drive.switch.ch/index.php/s/Q32FYIHoQeV6pXL/download" -O data.zip

wget "https://drive.switch.ch/index.php/s/nubhDEgA90g5c81/download" -O data.zip
unzip data.zip
rm data.zip
```

### Build docker 

TODO: Deprecated, this is gonna be abandon. Actually 

For amd64 architecture:
```
docker build -t sdsc-ord/eqasim:latest -f .docker/amd64/Dockerfile .       
```

For arm64 architecture:
```
docker build -t sdsc-ord/eqasim:latest -f .docker/arm64/Dockerfile .       
```

### How run docker interactively.

```
docker run -v {ABSOLUTE_PATH_TO_DATA_FOLDER}:/app/data -it sdsc-ord/eqasim:latest 
```

### How to run the synthetic population generation inside docker. 

```
cd ile-de-france
conda activate ile-de-france
python3 -m synpp
```

#### How to run the simulation: 

```
cd ../output
java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml
```

