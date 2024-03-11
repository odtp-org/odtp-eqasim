# ODTP Eqasim Component
ODTP component for running Eqasim. 

## Prepare dataset

1. IDF
    - Download the switchdrive zip file provided. 

2. CH
    - Download the data provided by Milos. Copy and paste all folders located in `hafas/2018` in `hafas`. 

3. Corsica
    - Download the switchdrive zip file provided. 

## How to run this component in docker. 

1. Prepare manually a folder called `odtp-input` containing the following datafolder of our selected scenario:

- data

2. Create your `.env` file with this structure.

Add the selected scenario `IDF`, or `CH`. Also select the eqasim pipeline you want to run `Synthesis`, or `Matsim`.

For Corsica:
```
SCENARIO=CORSICA
PIPELINE=Synthesis
processes=4
hts=entd
sampling_rate=0.001
random_seed=1234
java_memory=8GB
```

For IDF
```
SCENARIO=IDF
PIPELINE=Synthesis
processes=8
sampling_rate=0.001
random_seed=1234
java_memory=24G
hts=entd
```

For CH
```
SCENARIO=CH
PIPELINE=Synthesis
threads=4
random_seed=0
hot_deck_matching_runnners=2
java_memory=100G
input_downsampling=0.01
enable_scaling=true
scaling_year=2020
use_freight=true
hafas_date=01.10.2018
output_id=test
```

3. Build the dockerfile 

```
docker build -t odtp-eqasim .
```

4. Run the following command. Mount the correct volumes for input/output folders. 

```
docker run -it --rm \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-input \
-v {PATH_TO_YOUR_OUTPUT_VOLUME}:/odtp/odtp-output \
--env-file .env odtp-eqasim
```



## Example of tmux session

In this example you will run the isolated container with the CORSICA scenario.

```
tmux new -s odtp-test
docker run -it --rm \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-input \
-v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-output \ 
-e SCENARIO=CORSICA \
-e PIPELINE=Synthesis \
-e processes=4 \
-e hts=entd \
-e sampling_rate=0.001 \
-e random_seed=1234 \
-e java_memory=8GB \
--name odtp-eqasim odtp-eqasim
```

Now you can push Control + B, and then D to dettach from the tmux session. In order to come back to the session you can do: 

```
tmux attach-session -t odtp-test
```
If you want to kill the session just write `exit`. Also use `tmux ls` to list all available tmux sessions.

## Usage with ODTP

To connect this docker with an existing implementation of ODTP the following variables should be added to the env file. 

```
ODTP_MONGO_SERVER="mongodb://USER:PASSWORD@.....
ODTP_S3_SERVER=http://....
ODTP_BUCKET_NAME=...
ODTP_ACCESS_KEY=....
ODTP_SECRET_KEY=...
```


## Changelog

- v0.3.0 Corsica compatibility
    - Updating odtp-component-client to submodule
    - Output now delivers `eqasim-output` and `cache`. 

- v0.2.0: Version compatible with IDF & CH.

- v0.1.0: Version compatible with IDF & CH
    - Parameters. Now the parameters are taken from the enviroment variables. 
    - Configuration templates. No needs of copying config.yml file anymore. The file will be built based on the parameters.
    - Logger: If MongoDB arg. provided the container will log its activity in the db. 
    - S3 Compatibility: Output content, and snapshots can be uploaded to the S3 server.

- v.0.0.1: Version compatible with IDF

## Development. 

Developed by SDSC/CSFM.
