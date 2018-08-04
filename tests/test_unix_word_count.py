# to run unit tests, execute: pytest -v
import pytest
from jobs.word_count_solutions_with_tests import split_sentences_to_words, \
                                                 remove_non_alphabetical_characters, \
                                                 count_elements, \
                                                 sort_by_value_descending


@pytest.mark.usefixtures("spark_session")

def test_split_sentences_to_words(spark_session):
    test_input = ['hello spark', 'hello again']

    rdd = spark_session.sparkContext.parallelize(test_input)
    results = split_sentences_to_words(rdd)
    
    assert results.collect() == ['hello', 'spark', 'hello', 'again']

def test_remove_non_alphabetical_characters(spark_session):
    test_input = ['hello’!', 'spark?', 'hello?!', 'again.']

    rdd = spark_session.sparkContext.parallelize(test_input)
    results = remove_non_alphabetical_characters(rdd)
    
    assert results.collect() == ['hello', 'spark', 'hello', 'again']

def test_count_elements(spark_session):
    test_input = ['hello', 'spark', 'hello', 'again']

    rdd = spark_session.sparkContext.parallelize(test_input)
    results = count_elements(rdd)
    
    assert sorted(results.collect()) == sorted([('hello', 2), ('spark', 1), ('again', 1)])

def test_sort_by_value_descending(spark_session):
    test_input = [('spark', 1), ('again', 1), ('hello', 2)]

    rdd = spark_session.sparkContext.parallelize(test_input)
    print(rdd.collect())
    results = sort_by_value_descending(rdd)
    print(results.collect())
    
    assert results.collect() == [('hello', 2), ('spark', 1), ('again', 1)]