""" pytest fixtures that can be resued across tests. the filename needs to be conftest.py
"""

# make sure env variables are set correctly
import findspark  # this needs to be the first import
findspark.init()

import os

import logging
import pytest

from pyspark import SparkConf
from pyspark.sql import SparkSession


def quiet_py4j():
    """ turn down spark logging for the test context """
    logger = logging.getLogger('py4j')
    logger.setLevel(logging.WARN)

@pytest.fixture(scope="session")
def spark_session(request):
    """Fixture for creating a spark context."""

    spark = (SparkSession.builder
                .master("local[2]")
                .appName("pytest-pyspark-local-testing-2")
                .getOrCreate())

    request.addfinalizer(lambda: spark.stop())

    quiet_py4j()
    return spark
