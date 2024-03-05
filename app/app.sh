#!/bin/bash
if [ "$SCENARIO" == "IDF" ]; then
    echo "IDF SCENARIO."
    
    # Actions
    # A1 - Clone github
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout fb1112d2a7d1817746be84413da584c391059ad1

    # A2A - Prepare parameters & Config File
    # Read placeholders and create config file from Environment  
    if [ "$PIPELINE" == "Synthesis" ]; then
        echo "Running Synthesis PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_idf.yml /odtp/odtp-workdir/scenario/config.yml
    else
        echo "Running Matsim PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_idf.yml /odtp/odtp-workdir/scenario/config.yml
    fi

    # A2B - Prepare datafolder
    ln -s /odtp/odtp-volume/data /odtp/odtp-workdir/data

    # A3 - Run the tool
    python3 -m synpp
    #python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

    ## Matsim
    #java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

    # Copying output in odtp-output
    cp -r /odtp/odtp-workdir/output/* /odtp/odtp-output

elif [ "$SCENARIO" == "CORSICA" ]; then
    echo "CORSICA SCENARIO."
    
    # Actions
    # A1 - Clone github
    git clone https://github.com/eqasim-org/ile-de-france.git /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git checkout fb1112d2a7d1817746be84413da584c391059ad1

    # A2A - Prepare parameters & Config File
    # Read placeholders and create config file from Environment  
    if [ "$PIPELINE" == "Synthesis" ]; then
        echo "Running Synthesis PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_corsica.yml /odtp/odtp-workdir/scenario/config.yml
    else
        echo "Running Matsim PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_corsica.yml /odtp/odtp-workdir/scenario/config.yml
    fi

    # A2B - Prepare datafolder
    ln -s /odtp/odtp-input/data /odtp/odtp-workdir/data

    # A3 - Run the tool
    python3 -m synpp
    #python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

    ## Matsim
    #java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

    # Copying output in odtp-output
    cp -r /odtp/odtp-workdir/output/* /odtp/odtp-output

else
    echo "CH SCENARIO."

    # Actions
    # A1 - Clone github
    git clone https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop /odtp/odtp-workdir/scenario
    cd /odtp/odtp-workdir/scenario
    git switch develop
    git checkout 4658daa2e441dcda132622e7fcb47da1df8c47d6
    
    # A2A - Prepare parameters & Config File
    # Read placeholders and create config file from Environment  
    if [ "$PIPELINE" == "Synthesis" ]; then
        echo "Running Synthesis PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_synthesis_ch.yml /odtp/odtp-workdir/scenario/config.yml
    else
        echo "Running Matsim PIPELINE"
        python3 /odtp/odtp-client/parameters.py /odtp/odtp-app/config_templates/config_matsim_ch.yml /odtp/odtp-workdir/scenario/config.yml
    fi

    # A2B - Prepare datafolder
    ln -s /odtp/odtp-volume/data /odtp/odtp-workdir/data

    # A3 - Run the tool
    python3 -m synpp
    #python3 -m synpp /odtp/odtp-workdir/scenario/config.yml

    ## Matsim
    #java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml

    # Copying output in odtp-output
    cp -r /odtp/odtp-workdir/output/* /odtp/odtp-output
fi

