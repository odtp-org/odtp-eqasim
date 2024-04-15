#!/bin/bash
if [ "$SCENARIO" == "IDF" ]; then
    echo "IDF SCENARIO."
    
    # Cloning Scenario
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout fb1112d2a7d1817746be84413da584c391059ad1

    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables 
    echo "Running Synthesis PIPELINE"
    python3 /odtp/odtp-component-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_idf.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-component-client/data /odtp/odtp-workdir/data



elif [ "$SCENARIO" == "CORSICA" ]; then
    echo "CORSICA SCENARIO."
    
    # Cloning Scenario
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout fb1112d2a7d1817746be84413da584c391059ad1

    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables
    echo "Running Synthesis PIPELINE"
    python3 /odtp/odtp-component-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_corsica.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-input/data /odtp/odtp-workdir/data


else
    echo "CH SCENARIO."

    # Cloning Scenario
    git clone https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git switch develop
    git checkout 4658daa2e441dcda132622e7fcb47da1df8c47d6
    
    # Preparing parameters & config file
    # Reading placeholders and create config file from environment variables
    echo "Running Synthesis PIPELINE"
    python3 /odtp/odtp-component-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_ch.yml /odtp/odtp-workdir/scenario/config.yml

    # Preparing input data folder
    ln -s /odtp/odtp-component-client/data /odtp/odtp-workdir/data
    

fi

# Running Eqasim pipeline
python3 -m synpp


# Copying output in odtp-output
mkdir /odtp/odtp-output/eqasim-output
cp -r /odtp/odtp-workdir/output/* /odtp/odtp-output/eqasim-output

# Copying cache neccesary for running matsim.output in following steps
mkdir /odtp/odtp-output/cache
#cp /odtp/odtp-workdir/cache/pipeline.json /odtp/odtp-output/cache/pipeline.json
cp -r /odtp/odtp-workdir/cache/* /odtp/odtp-output/cache


