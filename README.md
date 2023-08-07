# ODTP Eqasim Component
ODTP component for running Eqasim. 

This component contains: 
1. Data loaders
2. Eqasim synthetic population generation
3. Matsim testing

Development phases: 

1. [x] Basic docker container that allows to run IDF scenario
2. [ ] Docker container compatible with more than one scenarios
3. [ ] ODTP single-component prototype
4. [ ] Eqasim division in 3 components:
    - Data loaders
    - Eqasim
    - Matsim


## First docker

Based in the pipeline for IDF a docker version able to run the synthetic dataset has been created. In order to build that docker you need to select 
one of the two compatible architecture `arm64` (Apple Silicon) or `amd64`. 

In order to access to the data, please run:

```
wget "https://drive.switch.ch/index.php/s/Q32FYIHoQeV6pXL/download" -O data.zip

wget "https://drive.switch.ch/index.php/s/nubhDEgA90g5c81/download" -O data.zip
unzip data.zip
rm data.zip
```

### Build docker 

For amd64 architecture:
```
docker build -t sdsc-ord/eqasim:latest -f .docker/amd64/Dockerfile .       
```

For arm64 architecture:
```
docker build -t sdsc-ord/eqasim:latest -f .docker/arm64/Dockerfile .       
```

### How run docker interactively.

```
docker run -v {ABSOLUTE_PATH_TO_DATA_FOLDER}:/app/data -it sdsc-ord/eqasim:latest 
```

### How to run the synthetic population generation inside docker. 

```
cd ile-de-france
conda activate ile-de-france
python3 -m synpp
```

#### How to run the simulation: 

```
cd ../output
java -Xmx20G -cp ile_de_france_run.jar org.eqasim.ile_de_france.RunSimulation --config-path ile_de_france_config.xml
```

## Error
```
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
  File "/odtp/odtp-workdir/scenario/synthesis/population/spatial/home/zones.py", line 39, in execute
    df_households["commune_id"].cat.add_categories(
  File "/usr/local/lib/python3.10/dist-packages/pandas/core/accessor.py", line 112, in f

  
    return self._delegate_method(name, *args, **kwargs)
  File "/usr/local/lib/python3.10/dist-packages/pandas/core/arrays/categorical.py", line 2475, in _delegate_method
    res = method(*args, **kwargs)
TypeError: Categorical.add_categories() got an unexpected keyword argument 'inplace'
```