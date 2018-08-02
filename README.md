# TWSG Data Engineering Bootcamp

### Setup
- Fork and clone repo
- Run `./setup.sh`

If you encounter any problems during the setup or during the labs, check our [troubleshooting guide](./troubleshooting-faq.md).

### Prerequisites
- An IDE (IntelliJ is recommended)

### Lab: HDFS
- Run bash shell in container: `docker run -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash`
- `cd $HADOOP_PREFIX`
- execute commands listed in lab!

### Lab: Spark
- Activate virtual env: `source .venv_data_eng_bootcamp/bin/activate`
- Define SPARK_HOME: `export SPARK_HOME=$(pwd)/spark-2.3.1-bin-hadoop2.7`
- To start spark in spark shell, run: `spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local`
- To start spark in jupyter notebook, run: `PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=notebook spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local`
- To deactivate the virtual environment, run: `deactivate`

TODOs
- add script to download data (from a GCP bucket?)
- add an option/step to mount a data volume with avro files or parquet files
