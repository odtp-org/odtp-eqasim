#!/bin/bash

# Actions
# A1 - Clone github
git clone https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop /odtp/odtp-workdir/scenario
cd /odtp/odtp-workdir/scenario
git switch develop


# A2 - Process configuration
cp /odtp/odtp-volume/config.yml /odtp/odtp-workdir/scenario/config.yml
ln -s /odtp/odtp-volume/data /odtp/odtp-workdir/data

# A3 - Run the tool
python3 -m synpp
#python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

## Matsim
#java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

# A4 - Take output and export it
zip -r output.zip /odtp/odtp-workdir/output
mv output.zip /odtp/odtp-volume/output.zip
#cp /odtp/odtp-workdir/log.txt /odtp/odtp-volume/log.txt
