#!/bin/bash

# Arguments
## By now just positional arguments
## $1 github scenario
## $2 config file to replace

# Actions #
# A1 - Clone github
git clone $1 /odtp/odtp-workdir/scenario

# A2 - Process configuration
cp /odtp/odtp-volume/config.yml /odtp/odtp-workdir/scenario/config.yml

# A3 - Run the tool
python3 -m synpp

## Matsim
#java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

# A4 - Take output and export it

# A5 - Kill Container