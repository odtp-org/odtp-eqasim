#!/bin/bash
echo "START COMPONENT"

## ODTP LOGGER in the background
python3 /odtp/odtp-app/logger.py >> /odtp/odtp-workdir/odtpLoggerDebugging.txt 2>&1 &

# Actions
# A1 - Clone github
git clone https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop /odtp/odtp-workdir/scenario
cd /odtp/odtp-workdir/scenario
git switch develop
git checkout b52736b70a5619bf5e01dabf9ead6994da9898b5


# A2 - Process configuration
cp /odtp/odtp-volume/config.yml /odtp/odtp-workdir/scenario/config.yml
ln -s /odtp/odtp-volume/data /odtp/odtp-workdir/data

# A3 - Run the tool
python3 -m synpp
#python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

## Matsim
#java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

# Take snapshot of workdir
zip -r workdir.zip /odtp/odtp-workdir

#  Take output and export it
zip -r output.zip /odtp/odtp-workdir/output

## Placing output i back in volume just for debugging
cp output.zip /odtp/odtp-volume/output.zip
cp workdir.zip /odtp/odtp-volume/workdir.zip

## Copying logs
cp /odtp/odtp-workdir/log.txt /odtp/odtp-volume/log.txt
cp /odtp/odtp-workdir/odtpLoggerDebugging.txt
cp /odtp/odtp-workdir/odtpS3UploadedDebugging.txt

## Save Snapshot in s3
mv output.zip /odtp/odtp-output/output.zip
mv workdir.zip /odtp/odtp-output/workdir.zip
