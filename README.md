# ODTP Eqasim Component
ODTP component for running Eqasim. 

## Prepare dataset

1. IDF
    - Download the switchdrive file provided in slack. 

2. CH
    - Download the data provided by Milos. Copy and paste all folders located in `hafas/2018` in `hafas`. 

## How to run this component in docker. 

1. Prepare manually a folder called volume containing the following datafolder of our selected scenario:

- data

2. Create your `.env` file with this structure. **If you do not have MONGODB and/or S3 activated omit this step, and just provide the scenario as environmental variable.**

```
SCENARIO=IDF
MONGODB_CLIENT=mongodb://.....
S3_SERVER=https://....
S3_ACCESS_KEY=Q0ISQ....
S3_SECRET_KEY=OoPthI....
S3_BUCKET_NAME=13301....
```

3. Build the dockerfile 

```
docker build -t odtp-eqasim .
```

3. Depending on your scenario add the parameters requested:

For IDF
```
processes=8
sampling_rate=0.001
random_seed=1234
java_memory=24G
hts=entd
```

For CH
```
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

4. Run the following command. Select the correct volume folder, the `SCENARIO` you want to simulate (`"IDF"` or `"CH"`) and the MONGODB_CLIENT URL. 

```
docker run -it --rm -v {PATH_TO_YOUR_VOLUME}:/odtp/odtp-volume --env-file .env odtp-eqasim
```

## Example of tmux session

In this example you will run the isolated container with the CH scenario.

```
tmux new -s odtp-test
docker run -it --rm -v /home/vivar/odtp-tutorial/volume-ch:/odtp/odtp-volume -e SCENARIO=CH --name odtp-test odtp-eqasim
```

Now you can push Control + B, and then D to dettach from the tmux session. In order to come back to the session you can do: 

```
tmux attach-session -t odtp-test
```
If you want to kill the session just write `exit`. Also use `tmux ls` to list all available tmux sessions.


## Description of files

- app/startup.ch
    - This file is the entrypoint. Check the scenario and keep log of all stout. 
- app/idf.ch
    - Pull IDF repo. Launch the pipeline. Activate logger and s3 uploaders. Compress output and workdir. 
- app/ch.ch
    - Pull CH repo. Launch the pipeline. Activate logger and s3 uploaders. Compress output and workdir. 
- logger.py
    - Check log.txt and uploads stout to MongoDB
- s3uploader.py
    - Upload output.zip & workdir.zip to S3. Create a mongodb entry. 

## Development. 

Developed by SDSC/CSFM.
