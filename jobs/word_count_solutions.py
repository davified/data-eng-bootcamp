import os, sys, re
from pyspark import SparkContext
from utils import get_absolute_path_of


if __name__ == "__main__":
    if len(sys.argv) != 2:
        file_name = __file__.split('/')[-1]
        sys.exit("[ERROR] Usage: {} textFile.txt".format(file_name))


    sc = SparkContext("local", "Word Count")

    text_file_path = sys.argv[1]

    distTextFile = sc.textFile(text_file_path)
    word_counts = distTextFile \
                    .flatMap(lambda sentence: sentence.split(' ')) \
                    .map(lambda word: re.compile('[^a-zA-Z]').sub('', word)) \
                    .map(lambda word: (word, 1)) \
                    .reduceByKey(lambda a, b: a + b) \
                    .sortBy(lambda pair: pair[1], ascending=False)

    print(word_counts.take(15))

