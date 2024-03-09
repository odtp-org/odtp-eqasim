# ODTP Eqasim Component
ODTP component for running Eqasim. 

## Prepare dataset

1. IDF
    - Download the switchdrive zip file provided. 

2. CH
    - Download the data provided by Milos. Copy and paste all folders located in `hafas/2018` in `hafas`. 

3. Corsica
    - Download the switchdrive zip file provided. 

## How to run this component in docker. 

1. Prepare manually a folder called volume containing the following datafolder of our selected scenario:

- data

2. Create your `.env` file with this structure. **If you do not have MONGODB and/or S3 activated omit this step, and just provide the scenario as environmental variable.**

Add the selected scenario `IDF`, or `CH`. Also select the eqasim pipeline you want to run `Synthesis`, or `matsim`.

```
SCENARIO=IDF
PIPELINE=Synthesis
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

3. Depending on your scenario add the parameters requested:

For Corsica:
```
SCENARIO=CORSICA
PIPELINE=Synthesis
processes=4
hts=entd
sampling_rate=0.001
random_seed=1234
java_memory=8GB
```

For IDF
```
SCENARIO=IDF
PIPELINE=Synthesis
processes=8
sampling_rate=0.001
random_seed=1234
java_memory=24G
hts=entd
```

For CH
```
SCENARIO=CH
PIPELINE=Synthesis
threads=4
random_seed=0
hot_deck_matching_runnners=2
java_memory=100G
input_downsampling=0.01
enable_scaling=true
scaling_year=2020
use_freight=true
hafas_date=01.10.2018
output_id=test
```

4. Run the following command. Select the correct volume folder, the `SCENARIO` you want to simulate (`"IDF"`, `CORSICA`, or `"CH"`) and the MONGODB_CLIENT URL. 

```
docker run -it --rm -v {PATH_TO_YOUR_INPUT_VOLUME}:/odtp/odtp-input -v {PATH_TO_YOUR_OUTPUT_VOLUME}:/odtp/odtp-output --env-file .env odtp-eqasim
```

## Example of tmux session

In this example you will run the isolated container with the CH scenario.

```
tmux new -s odtp-test
docker run -it --rm -v /home/vivar/odtp-tutorial/volume-ch:/odtp/odtp-volume -e SCENARIO=CH --name odtp-test odtp-eqasim
```

Now you can push Control + B, and then D to dettach from the tmux session. In order to come back to the session you can do: 

```
tmux attach-session -t odtp-test
```
If you want to kill the session just write `exit`. Also use `tmux ls` to list all available tmux sessions.


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
- parameters.py
    - Takes care of replacing the placeholder on the config templates.

## Changelog

- v0.2.0: Version compatible with IDF, CH & Corsica

- v0.1.0: Version compatible with IDF & CH
    - Parameters. Now the parameters are taken from the enviroment variables. 
    - Configuration templates. No needs of copying config.yml file anymore. The file will be built based on the parameters.
    - Logger: If MongoDB arg. provided the container will log its activity in the db. 
    - S3 Compatibility: Output content, and snapshots can be uploaded to the S3 server.

- v.0.0.1: Version compatible with IDF

## Development. 

Developed by SDSC/CSFM.


[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for eqasim 1.3.1:
[INFO] 
[INFO] eqasim ............................................. FAILURE [03:04 min]
[INFO] core ............................................... SKIPPED
[INFO] ile_de_france ...................................... SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  03:07 min
[INFO] Finished at: 2024-03-09T11:59:38Z
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal on project eqasim: Could not resolve dependencies for project org.eqasim:eqasim:pom:1.3.1: Could not transfer artifact org.geotools:gt-opengis:jar:24.2 from/to osgeo (https://repo.osgeo.org/repository/release/): GET request of: org/geotools/gt-opengis/24.2/gt-opengis-24.2.jar from osgeo failed: Connection reset -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/DependencyResolutionException
Traceback (most recent call last):
  File "/usr/lib/python3.10/runpy.py", line 196, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "/usr/lib/python3.10/runpy.py", line 86, in _run_code
    exec(code, run_globals)
  File "/usr/local/lib/python3.10/dist-packages/synpp/__main__.py", line 14, in <module>
    synpp.run_from_yaml(config_path)
  File "/usr/local/lib/python3.10/dist-packages/synpp/pipeline.py", line 886, in run_from_yaml
    Synpp.build_from_yml(path).run_pipeline()
  File "/usr/local/lib/python3.10/dist-packages/synpp/pipeline.py", line 910, in run_pipeline
    return run(definitions, self.config, self.working_directory, flowchart_path=flowchart_path,
  File "/usr/local/lib/python3.10/dist-packages/synpp/pipeline.py", line 810, in run
    result = stage["wrapper"].execute(context)
  File "/usr/local/lib/python3.10/dist-packages/synpp/pipeline.py", line 88, in execute
    return self.instance.execute(context)
  File "/odtp/odtp-workdir/scenario/matsim/runtime/eqasim.py", line 55, in execute
    maven.run(context, ["-Pstandalone", "--projects", "ile_de_france", "--also-make", "package", "-DskipTests=true"], cwd = "%s/eqasim-java" % context.path())
  File "/odtp/odtp-workdir/scenario/matsim/runtime/maven.py", line 34, in run
    return_code = sp.check_call(command_line, cwd = cwd)
  File "/usr/lib/python3.10/subprocess.py", line 369, in check_call
    raise CalledProcessError(retcode, cmd)
subprocess.CalledProcessError: Command '['/tmp/maven/apache-maven-3.6.3/bin/mvn', '-Djava.io.tmpdir=/odtp/odtp-workdir/cache/matsim.runtime.eqasim__e6e89366dc968ee0f589299abca885c6.cache/__java_temp', '-Pstandalone', '--projects', 'ile_de_france', '--also-make', 'package', '-DskipTests=true']' returned non-zero exit status 1.
mkdir: cannot create directory '/odtp/odtp-output/eqasim-output': File exists