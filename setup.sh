#!/usr/bin/env bash

install_brew_formula() {
  local dependency_name=$1
  local use_cask=$2
  local executable_name=$3

  if [[ $3 == '' ]]; then
    executable_name=$dependency_name
  fi

  which $executable_name
  if [ $? -ne 0 ]; then
    echo "[INFO] Installing $dependency_name..."
    if [[ $use_cask == "--cask" ]]; then
      brew cask install $dependency_name
    else
      brew install $dependency_name
    fi
  fi
}

install_brew_formula "docker" "--cask"
install_brew_formula "java" "--cask"
install_brew_formula "maven" "" "mvn"
install_brew_formula "wget"
install_brew_formula "python3"



open --background -a Docker
while ! docker system info > /dev/null 2>&1; do sleep 1 && echo "[INFO] Waiting for docker daemon startup to complete..."; done

echo "[INFO] Pulling Apache Hadoop 2.7.0 Docker image..."
docker pull sequenceiq/hadoop-docker:2.7.1

mkdir -p opt

echo "[INFO] Downloading and installing Spark..."
if [[ ! -f ./opt/spark-2.3.1-bin-hadoop2.7.tgz ]]; then
  wget -P ./opt http://www-eu.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz 
fi

if [[ ! -d spark-2.3.1-bin-hadoop2.7 ]]; then
  tar xvf ./opt/spark-2.3.1-bin-hadoop2.7.tgz -C .
fi

echo "[INFO] Spark installed."

virtual_environment_name=.venv_data_eng_bootcamp
if [ ! -d ${virtual_environment_name} ]; then
  echo "[INFO] Creating virtual env folder in current directory"
  python3 -m venv ${virtual_environment_name}
fi

echo "Installing dependencies"
source ${virtual_environment_name}/bin/activate
pip3 install -r requirements.txt
python3 -m ipykernel install --user --name ${virtual_environment_name} --display-name "${virtual_environment_name}"

echo '============================================='
echo '[INFO] Setup complete!'
echo '[INFO] ============== Get data =============='
echo '[INFO] To get data for the labs, run: ./get_data.sh'
echo '[INFO] ======= Commands for HDFS Lab ========'
echo '[INFO] docker run -v $(pwd)/data:/usr/local/data/ -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash'
echo ''
echo '[INFO] ======= Commands for Spark Lab ======='
echo "[INFO] To activate virtual env: source ${virtual_environment_name}/bin/activate"
echo '[INFO] Define spark home: export SPARK_HOME=$(pwd)/spark-2.3.1-bin-hadoop2.7'
echo '[INFO] To start spark in spark shell, run: $SPARK_HOME/bin/pyspark --master local'
echo '[INFO] To start spark in jupyter environment, run: PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=notebook spark-2.3.1-bin-hadoop2.7/bin/pyspark --master local'
echo '[INFO] To deactivate the virtual environment, run: deactivate'
