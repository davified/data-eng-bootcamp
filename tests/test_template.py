import pytest
# from jobs.your_file import your_func

@pytest.mark.usefixtures("spark_session")

def test_a_test_template(spark_session):
    df = spark_session.read.text("./data/people/names.json") # replace with your file
    

