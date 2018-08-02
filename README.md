# TWSG Data Engineering Bootcamp

### Setup
- Fork and clone repo
- Run `./setup.sh`
- Run `./get_data.sh`

If you encounter any problems during the setup or during the labs, check our [troubleshooting guide](./troubleshooting-faq.md).

#### Prerequisites
- An IDE (IntelliJ is recommended)

### Lab: HDFS
- Run bash shell in container: `docker run -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash`
- `cd $HADOOP_PREFIX`
- execute commands listed in lab!

### Lab: Spark
- Define SPARK_HOME: `export SPARK_HOME=$(pwd)/spark-2.3.1-bin-hadoop2.7`
- Activate virtual env: `source .venv_data_eng_bootcamp/bin/activate`
- To start spark in spark shell, run: `$SPARK_HOME/bin/pyspark --master local`
- To start spark in jupyter notebook, run: `PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=notebook $SPARK_HOME/bin/pyspark --master local`
- To deactivate the virtual environment, run: `deactivate`
