#!/bin/bash

#########################################################
# ODTP COMPONENT TEMPLATE
#########################################################

echo "STARTING ODTP COMPONENT"
sleep 2

## ODTP LOGGER in the background
if [ -v ODTP_MONGO_SERVER ]; then
    echo "STARTING LOGGING IN MONGO SERVER"
    python3 /odtp/odtp-client/logger.py >> /odtp/odtp-logs/odtpLoggerDebugging.txt 2>&1 &
else
    echo "ODTP_MONGO_URL does not exist"
fi


############################################################################################
# USER APP
############################################################################################

bash /odtp/odtp-app/app.sh

############################################################################################
# END OF USER APP
############################################################################################

#########################################################
# COMPRESS THE OUTPUT FOLDER GENERATED
#########################################################

#  Take output and export it
cd /odtp/odtp-output
zip -r /odtp/odtp-output/odtp-output.zip /odtp/odtp-output

#########################################################
# ODTP SNAPSHOT CREATION 
#########################################################

# Take snapshot of workdir
cd /odtp/
zip -r /odtp/odtp-output/odtp-snapshot.zip odtp-workdir


## Saving Snapshot in s3

if [[ -v ODTP_S3_SERVER && -v ODTP_MONGO_SERVER ]]; then
    echo "Uploading to ODTP_S3_SERVER"
    python3 /odtp/odtp-client/s3uploader.py 2>&1 | tee /odtp/odtp-logs/odtpS3UploadedDebugging.txt  
else
    echo "ODTP_S3_SERVER does not exist"
fi

# ## Copying logs into output 
# cp /odtp/odtp-logs/log.txt /odtp/odtp-output/log.txt

# if [ -v ODTP_S3_SERVER ]; then
#     cp /odtp/odtp-logs/odtpLoggerDebugging.txt /odtp/odtp-output/odtpLoggerDebugging.txt
# else
#     echo "ODTP_S3_SERVER doesn't exist. Not copying log files."
# fi

# if [[ -v ODTP_S3_SERVER && -v ODTP_MONGO_SERVER ]]; then
#     cp /odtp/odtp-logs/odtpS3UploadedDebugging.txt /odtp/odtp-output/odtpS3UploadedDebugging.txt
# else
#     echo "ODTP_S3_SERVER doesn't exist. Not copying log files."
# fi