#!/usr/bin/env bash

# install docker and docker-compose?

echo "[INFO] Downloading and installing Spark"

if [[ ! -f spark-2.3.1-bin-hadoop2.7.tgz ]]; then
  wget http://www-eu.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz 
fi

if [[ ! -d spark-2.3.1-bin-hadoop2.7 ]]; then
  tar xvf spark-2.3.1-bin-hadoop2.7.tgz
fi

echo "[INFO] Spark installed."



virtual_environment_name=.venv_data_eng_bootcamp
which python3
if [ $? -ne 0 ]; then
  echo "[INFO] Installing python 3"
  brew install python3
fi

if [ ! -d ${virtual_environment_name} ]; then
  echo "[INFO] Creating virtual env folder in current directory"
  python3 -m venv ${virtual_environment_name}
fi

echo "Installing dependencies"
source ${virtual_environment_name}/bin/activate
pip3 install jupyter
python3 -m ipykernel install --user --name ${virtual_environment_name} --display-name "${virtual_environment_name}"


echo '[INFO] Run the following commands'
echo "source ${virtual_environment_name}/bin/activate"
echo 'export SPARK_HOME="$(pwd)/spark-2.3.1-bin-hadoop2.7"'

echo '[INFO] To start spark in spark shell, run: spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local'
echo '[INFO] To start spark in jupyter environment, run: PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=notebook spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local'
echo '[INFO] To deactivate the virtual environment, run: deactivate'
