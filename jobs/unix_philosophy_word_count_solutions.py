from pyspark import SparkContext
import os, re


sc = SparkContext("local", "Unix Word Count")
def get_absolute_path_of(relative_filepath):
    import os
    project_dir_name = 'twsg-data-eng-bootcamp'
    project_root_dir = os.getcwd().split(project_dir_name)[0] + project_dir_name
    return "{}/{}".format(project_root_dir, relative_filepath)

# path to text file. unfortunate hackiness to make sure we can
text_file_path = get_absolute_path_of("data/word_count/unix-philosophy-basics.txt")

distTextFile = sc.textFile(text_file_path)
word_counts = distTextFile \
                .flatMap(lambda sentence: sentence.split(' ')) \
                .map(lambda word: re.compile('[^a-zA-Z]').sub('', word)) \
                .map(lambda word: (word, 1)) \
                .reduceByKey(lambda a, b: a + b) \
                .sortBy(lambda pair: pair[1], ascending=False)

print(word_counts.take(15))

