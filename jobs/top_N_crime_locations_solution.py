from pyspark.sql import SparkSession
from pyspark.sql.functions import desc
from utils import get_absolute_path_of


spark = SparkSession.builder.appName("Top N Locations for Crimes").getOrCreate()

crimes = spark.read.csv(get_absolute_path_of("data/crimes/Crimes_-_One_year_prior_to_present.csv"), header=True, inferSchema=True)

columnNames = crimes.columns
for col in columnNames:
    crimes = crimes.withColumnRenamed(col, col.strip())


top_locations = crimes.groupBy('LOCATION DESCRIPTION').count().sort(desc("count")).limit(5)
top_locations.coalesce(1).write.mode("overwrite").csv(get_absolute_path_of("data/top_locations"), header=True)
