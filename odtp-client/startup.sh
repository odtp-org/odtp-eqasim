#!/bin/bash
echo "RUNNING THE APP"
touch /odtp/odtp-logs/log.txt
touch /odtp/odtp-logs/odtpLoggerDebugging.txt
touch /odtp/odtp-logs/odtpS3UploadedDebugging.txt 

if [ "$SCENARIO" == "IDF" ]; then
    echo "IDF SCENARIO."
    bash /odtp/odtp-app/idf.sh 2>&1 | tee /odtp/odtp-workdir/log.txt
else
    echo "CH SCENARIO."
    bash /odtp/odtp-app/ch.sh 2>&1 | tee /odtp/odtp-workdir/log.txt
fi

echo "--- ODTP COMPONENT ENDING ---" >> /odtp/odtp-workdir/log.txt

# Leaving some time for logging to catch up
sleep 10

# Zip logs
zip -r /odtp/odtp-output/odtp-logs.zip odtp-logs