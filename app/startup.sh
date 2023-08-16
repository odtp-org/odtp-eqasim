#!/bin/bash
if [ "$SCENARIO" == "idf" ]; then
    echo "IDF SCENARIO."
    bash /odtp/odtp-app/idf.sh 2>&1 | tee /odtp/odtp-workdir/log.txt
else
    echo "CH SCENARIO."
    bash /odtp/odtp-app/ch.sh 2>&1 | tee /odtp/odtp-workdir/log.txt
fi

echo "--- ODTP COMPONENT ENDING ---" >> /odtp/odtp-workdir/log.txt