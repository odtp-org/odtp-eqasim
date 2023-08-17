# ODTP Eqasim Component
ODTP component for running Eqasim. 


## Prepare dataset

1. IDF
    - Download the switchdrive file provided in slack. 

2. CH
    - Download the data provided by Milos. Copy and paste all folders located in `hafas/2018` in `hafas`. 

## How to run this component in docker. 

1. Prepare manually a folder called volume containing the following files of our selected scenario:

- data
- config.yml 

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

4. Run the following command. Select the correct volume folder, the `SCENARIO` you want to simulate (`"IDF"` or `"CH"`) and the MONGODB_CLIENT URL. 

```
docker run -it --rm -v {PATH_TO_YOUR_VOLUME}:/odtp/odtp-volume --env-file .env odtp-eqasim
```

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



