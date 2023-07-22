#!/bin/bash

# Arguments
## By now just positional arguments
## $1 github scenario
## $2 config file to replace

# Actions #
# A1 - Clone github
# git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
# git reset --hard 18aa1d4
# git checkout 18aa1d4
git clone $1 /odtp/odtp-workdir/scenario #GITHUB
git checkout $2 #COMMIT


# A2 - Process configuration
cp /odtp/odtp-volume/config.yml /odtp/odtp-workdir/scenario/config.yml
ln -s /odtp/odtp-volume/data /odtp/odtp-workdir/data

# A3 - Run the tool
cd /odtp/odtp-workdir/scenario
python3 -m synpp
#python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

## Matsim
#java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

# A4 - Take output and export it

# A5 - Kill Container