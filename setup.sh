#!/usr/bin/env bash

which docker 
if [ $? -ne 0 ]; then
  echo "[INFO] Installing docker..."
  brew cask install docker
fi

which wget 
if [ $? -ne 0 ]; then
  echo "[INFO] Installing wget..."
  brew install wget 
fi

open --background -a Docker
# TODO: properly check if docker daemon is running before opening it again 
echo "[INFO] Arbitrarily sleeping for 30 seconds while waiting for Docker Daemon to boot up..." 
#sleep 30

echo "[INFO] Pulling Apache Hadoop 2.7.0 Docker image..."
docker pull sequenceiq/hadoop-docker:2.7.1

echo "[INFO] Downloading and installing Spark..."
if [[ ! -f spark-2.3.1-bin-hadoop2.7.tgz ]]; then
  wget http://www-eu.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz 
fi

if [[ ! -d spark-2.3.1-bin-hadoop2.7 ]]; then
  tar xvf spark-2.3.1-bin-hadoop2.7.tgz
fi

echo "[INFO] Spark installed."

which python3
if [ $? -ne 0 ]; then
  echo "[INFO] Installing python 3"
  brew install python3
fi

virtual_environment_name=.venv_data_eng_bootcamp
if [ ! -d ${virtual_environment_name} ]; then
  echo "[INFO] Creating virtual env folder in current directory"
  python3 -m venv ${virtual_environment_name}
fi

echo "Installing dependencies"
source ${virtual_environment_name}/bin/activate
pip3 install ipykernel
pip3 install jupyter
pip3 install numpy
python3 -m ipykernel install --user --name ${virtual_environment_name} --display-name "${virtual_environment_name}"

echo '============================================='
echo '[INFO] Done!'
echo '[INFO] ======= Commands for HDFS Lab ======='
echo '[INFO] docker run -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash'
echo ''
echo '[INFO] ======= Commands for Spark Lab ======'
echo "[INFO] To activate virtual env: source ${virtual_environment_name}/bin/activate"
echo "[INFO] Define spark home: export SPARK_HOME=spark-2.3.1-bin-hadoop2.7"
echo '[INFO] To start spark in spark shell, run: spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local'
echo '[INFO] To start spark in jupyter environment, run: PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=notebook spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local'
echo '[INFO] To deactivate the virtual environment, run: deactivate'
