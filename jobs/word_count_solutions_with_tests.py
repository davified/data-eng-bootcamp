import sys, os, re
from pyspark import SparkContext

def split_sentences_to_words(rdd):
    return rdd.flatMap(lambda sentence: sentence.split(' '))

def remove_non_alphabetical_characters(rdd):
    return rdd.map(lambda word: re.compile('[^a-zA-Z]').sub('', word)) \

def count_elements(rdd):
    return rdd.map(lambda element: (element, 1)) \
              .reduceByKey(lambda a, b: a + b)

def sort_by_value_descending(rdd):
    return rdd.sortBy(lambda pair: pair[1], ascending=False)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        file_name = __file__.split('/')[-1]
        sys.exit("[ERROR] Usage: {} textFile.txt".format(file_name))

    sc = SparkContext("local", "Word Count Demo")

    rdd = sc.textFile(sys.argv[1])
    rdd = split_sentences_to_words(rdd)
    rdd = remove_non_alphabetical_characters(rdd)
    rdd = count_elements(rdd)
    word_counts = sort_by_value_descending(rdd)

    print(word_counts.take(15))

