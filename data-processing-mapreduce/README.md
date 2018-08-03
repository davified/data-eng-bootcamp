## Hands-on
### Practice 1
In this practice, we will write a MapReduce wordcount program with **Java**. There are some prerequirements in this hands-on

- Already install Java, Maven, Intellij, Docker and Hadoop in the local
- Have some basic skills in Java and can write simple java program

Below are steps we will go through:

- Create maven project
- Import maven dependencies
- Create Mapper
- Create Reducer
- Create Driver
- Create sample data
- Run the program inside of IDE

### Steps for setting up

#### Step 1. Create maven project 
##### Option 1:  Create maven project with IntelliJ

Create a new Maven project with IntelliJ with below info:
```xml
<modelVersion>4.0.0</modelVersion>
<groupId>com.bootcamp.practice</groupId>
<artifactId>data-training</artifactId>
<version>1.0-SNAPSHOT</version>
```
If you have any problems please check this [link](https://www.jetbrains.com/help/idea/maven-support.html) to see how to create maven project

##### Option 2:  Create maven project from terminal
If you want to create project with maven, check below:
```
mvn archetype:generate -DgroupId=com.bootcamp.practice \
   -DartifactId=data-training \
   -DarchetypeArtifactId=maven-archetype-quickstart  \
   -DinteractiveMode=false
```

#### Step 2. Import maven dependencies
In order to write MapReduce program, we need to have below dependencies. Add the following snippet in `pom.xml` 
```xml
<dependencies>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-common</artifactId>
        <version>3.0.1</version>
    </dependency>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-client</artifactId>
        <version>3.0.1</version>
    </dependency>
</dependencies>

```

## Writing our MapReduce program!

#### Create Mapper
Before we create a mapper, we create package `com.practice.mapreduce.wordcount` to hold all the wordcount classes.

Then we create WordCountMapper like below
```java
package com.practice.mapreduce.wordcount;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class WordCountMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

    @Override
    public void map(LongWritable key, Text value, Context context) {
        ...
    }
}
```

Note:
1. We import `org.apache.hadoop.mapreduce.Mapper` instead of `import org.apache.hadoop.mapred.Mapper` because of the classes inside of mapred is below MR v1. in this session we use the new version interface.
2. We need to extends Mapper and override map function to customize our own mapper
3. The declaration of the Mapper is `Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT>`. please careful about the input and output.
4. In this program we need to use `LongWritable` and `Text` because we use default InputFormat `TextInputFormat `. see more details [Hadoop InputFormat](https://data-flair.training/blogs/hadoop-inputformat/)
5. All the input value and output value should implement `Writable`
6. The `Context` here is a full program context, can use to share configuration and variables.

#### Create Reducer

The ways to create reducer is similar with mapper. 
-  Need to extends one `org.apache.hadoop.mapreduce.Reducer` class. 
-  Need to Override reduce function
-  Need to care about input <key,value> and output <key,value>

Then we create WordCountReducer like below
```java
package com.practice.mapreduce.wordcount;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;


public class WordCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context) {
        ...
    }
}
```

Note: 
1. The value type in reduce method is `Iterable<IntWritable>`. This is because the default shuffle will group the values for the same key. even though there are only one value. the type will still be Iterable.

#### Create Driver
We call it Driver but actually it's just a normal main method which call MR interface to run our program. it's totally different with Spark's Driver.

We use below codes to create Driver
```java
package com.practice.mapreduce.wordcount;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

public class WordCountDriver {

    public static void main(String... args) throws IOException,
            ClassNotFoundException, InterruptedException {
        if (args.length < 2) {
            throw new IllegalArgumentException("Wrong arguments, at least two");
        }
        Job job = getJob(args);
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }

    public static Job getJob(String[] args) throws IOException {
       ...
    }
}
```  

The key logic here is:
- Create job based on arguments
- Program exit when job complete

Then below are code to create the job
```java
public static Job getJob(String[] args) throws IOException {
        // get job
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCountDriver.class);

        // set input and output
        FileInputFormat.addInputPath(job, new Path(args[0]));
        Path outputDir = new Path(args[1]);
        FileOutputFormat.setOutputPath(job, outputDir);
        
        // set output key value type
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        
        // set Mapper and Reducer class
        job.setMapperClass(WordCountMapper.class);
        job.setReducerClass(WordCountReducer.class);

        // set combiner. this will improve the performance
        job.setCombinerClass(WordCountReducer.class);

        //delete the output dir
        outputDir.getFileSystem(conf).delete(outputDir);
        return job;
    }
```
Note:

- `setOutputKeyClass` and `setOutputValueClass` are used to set output <key,value> type for Reducer.
- `setCombinerClass` will improve the performance. because it will combine the same key before shuffle.
- `setJarByClass` will help the program to finding where a given class came from. if we didn't set, it will throw `ClassNotFoundException`

#### Create sample data
This is simple. we just create some sample txt file `sample.txt` inside `resources` folder. 
we put below very simple content first
```
hello world
hello hadoop
```

#### Run the program inside of IDE

1. Click on the Run button next to the Driver class (it's green), and wait for the build to complete
2. Right click resources/sample.txt and Copy Path
3. On the top right of the screen, click on Driver > 'Edit configurations...'. Paste the path to sample.txt as indicated in the screenshot below.
4. Run and check the output

The program config in IDE looks like below:

![image.png](https://upload-images.jianshu.io/upload_images/4413464-d2e17a9d5d732268.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

The after you run the program you will see an `output` folder inside of you project.
looks like below.

![image.png](https://upload-images.jianshu.io/upload_images/4413464-cf22e9c493bacbbb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

After you open the file `part-r-00000`.  you will see the output like below
```
hadoop	1
hello	2
world	1
```

In order to see the logs. we add `log4j.properties` inside of `resources` folder, the file content look like below:
```text
# Root logger option
log4j.rootLogger=INFO, stdout

# Direct log messages to stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.Target=System.out
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss} %-5p %c{1}:%L - %m%n

```

Congratulations !! you finish the first practice

### Practice 2
In this practice, we will use the result of practice one to get the top N words. The number of N can be set as parameter.

The steps are below:
- Create Mapper
- Create Reducer
- Create Partitioner
- *Create Comparator
- Create Driver
- Run the program

#### Create Mapper
In this Mapper, we need to read the result from WordCountMapper. before this, let's create package `com.practice.mapreduce.topN` to hold all the topN related classes 

There are slight difference between the `WordCountMapper` and `TopNMapper`. let's look at the code below:
```java
package com.practice.mapreduce.topN;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;
import java.util.TreeMap;

public class TopNMapper extends
        Mapper<Text, Text, Text, IntWritable> {

    private final TreeMap<Integer, String> resultMap = new TreeMap<>();
    private int top_n;

    @Override
    public void setup(Context context) {
        // we need to get the top.n parameter in there
    }

    @Override
    public void map(Text key, Text value, Context context) {
       // we retain the top n records in the TreeMap 
    }

    @Override
    public void cleanup(Context context) throws IOException, InterruptedException {
        // we commit the data into reduce phase in there
    }
}

```

Note:
- The first needs to note is we add `setup` and `cleanup` methods in this Mapper
The lifecycle of the Map taks is `setup -> map -> cleanup`. the `setup` and `cleanup` are two different hooks. 
   + For the `setup` method, the common use case is read parameters from configuration object, open connection to database. In this case, we use it to read `top.n` parameter.
   + For the `cleanup` method, the common use case are flush out accumulation of aggregate results or close the connection. in this case, we use it to flush out the topN results.

- The second needs to note is the input type of key and value changed to **Text** respectively. As we save the word count result as key value pair. we use `KeyValueTextInputFormat` to load the data instead of default `TextInputFormat`
- The last thing needs to note is we use **TreeMap** to sorting by key. and only keep number of k values inside.

#### Create Reducer
The main concept here is same. Based on the top n which sent from Mapper, we select overall top n inside of Reducer. The code looks like below:
```java
package com.practice.mapreduce.topN;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;
import java.util.TreeMap;

public class TopNReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

    private TreeMap<Integer, String> resultMap = new TreeMap<>();
    private int topN = 5;

    @Override
    public void setup(Context context) {
        // read the configuration from context
    }

    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context) {
        // do aggregation for the values and save it into resultMap
    }

    @Override
    public void cleanup(Context context) throws IOException, InterruptedException {
        // flush out the treeMap result.
    }
}
```

Note:
All the concepts are same as before. The type of value in reduce method is `Iterable<IntWritable>`

#### Create Partitioner
In order to solve the problem of skewed data, we customize partitioner to balance the data. 
The code looks like below:
```java
package com.practice.mapreduce.topN;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Partitioner;

public class TopNPartitioner extends Partitioner<Text, IntWritable> {
    @Override
    public int getPartition(Text key, IntWritable value, int numPartitions) {
        // based on the first character of key, we send it to different partition.
        // the return value is the partition number for the key.
    }
}
```

Notes:
- we extends `Partitioner` to create our own partitioner. Partitioner controls the partitioning of the keys of the intermediate map-outputs. The key (or a subset of the key) is used to derive the partition, typically by a hash function
- The total number of partitions is the same as the number of reduce tasks for the job, the partitioner only created when there are multiple reduce tasks.
- The types of `Text` and `IntWritable` are map output key and value.

#### Create Driver
Most part of the driver is same, only some little differences, check the code below:
```java
package com.practice.mapreduce.topN;


import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;

public class TopNDriver {

    public static void main(String... args) throws IOException, ClassNotFoundException, InterruptedException {

        if (args.length < 2) {
            throw new IllegalArgumentException("Should have more than 2 arguments");
        }
        Job job = getJob(args);
        System.exit(job.waitForCompletion(true) ? 0 : 1);

    }

    public static Job getJob(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.setInt("top.n", 6);

        Job job = Job.getInstance(configuration);
        job.setJarByClass(TopNDriver.class);

        Path inputPath = new Path(args[0]);
        FileInputFormat.addInputPath(job, inputPath);

        Path outputDir = new Path(args[1]);
        FileOutputFormat.setOutputPath(job, outputDir);

        job.setMapperClass(TopNMapper.class);
        job.setReducerClass(TopNReducer.class);
        job.setNumReduceTasks(2);

        job.setCombinerClass(TopNReducer.class);
        job.setPartitionerClass(TopNPartitioner.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        job.setInputFormatClass(KeyValueTextInputFormat.class);
        outputDir.getFileSystem(configuration).delete(outputDir);

        return job;
    }
}
```

Notes:
- First difference is we need to set `top.n` parameter throught Configuration
- Second is we need to set number of reduce tasks to 2 throught call `setNumReduceTasks`
- Third is we use `setPartitionerClass` to use our customize partitioner
- The last one is we use another ** KeyValueTextInputFormat** which the key and value are all type of `Text`

#### *Create Comparator
Some times we need to make our result sorted. for this case we need to customize comparator. we will skip code implementation of comparator in this hands-on. everybody can do it as homework. 
The overview steps are:
- Extends `WritableComparator` and implement `compare` method
- set comparator class when we initialize job

Note: there are two types of Comparator here. which are `SortComparator` and `GroupingComparator` the general different here is : `SortComparator` decides how map output keys are sorted while `GroupComparator` decides which map output keys within the Reducer go to the same reduce method call.

#### Run the program
How to run the program is same as run wordcount program. will not share more details here.

Congratuations!! you finish the second practice. 

### Practice 3
In this practice, we will chain this two mapreduce jobs together. 
The only change we need to make is create another **Driver** to orchestrate the MR jobs, check the code below
```java
package com.practice.mapreduce;

import com.practice.mapreduce.topN.TopNDriver;
import com.practice.mapreduce.wordcount.WordCountDriver;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.jobcontrol.ControlledJob;
import org.apache.hadoop.mapreduce.lib.jobcontrol.JobControl;

import java.io.IOException;

public class ChainDriver {

    public static void main(String... args) throws IOException {

        if (args.length < 3) {
            throw new IllegalArgumentException("arguments should more than 3");
        }

        JobControl jobControl = new JobControl("jobChain");

        String[] wordCountArgs = new String[]{args[0], args[1]};
        Job job1 = WordCountDriver.getJob(wordCountArgs);
        ControlledJob controlledJob1 = new ControlledJob(job1.getConfiguration());

        String[] topNArgs = new String[]{args[1], args[2]};
        Job job2 = TopNDriver.getJob(topNArgs);
        ControlledJob controlledJob2 = new ControlledJob(job2.getConfiguration());


        jobControl.addJob(controlledJob1);
        jobControl.addJob(controlledJob2);

        controlledJob2.addDependingJob(controlledJob1);

        Thread jobRunnerThread = new Thread(new JobRunner(jobControl));
        jobRunnerThread.start();

        while (!jobControl.allFinished()) {
            System.out.println("Jobs in running state: " + jobControl.getRunningJobList().size());
            System.out.println("Jobs in success state: " + jobControl.getSuccessfulJobList().size());
            System.out.println("Jobs in failed state: " + jobControl.getFailedJobList().size());
        }
        System.out.println("done");
        jobControl.stop();
    }
}
```

Notes:
- We use `JobControl` to control the flow of jobs
- There are three argumets here, `args[0]` is the input for wordcount job, `args[1]` is the output for wordcount job also the input for the topN job, `args[2]` is the the output for the topN job.
- We need to call `addDependingJob ` to set the sequence of jobs.
- In this case we create another class `JobRunner` to run the program.
- We can monitor the status of the jobs by call `getRunningJobList`, `getSuccessfulJobList` and `getFailedJobList ` method. 

The **JobRunner** class looks like below:
```java
package com.practice.mapreduce;

import org.apache.hadoop.mapreduce.lib.jobcontrol.JobControl;

public class JobRunner implements Runnable {
    private JobControl control;

    public JobRunner(JobControl _control) {
        this.control = _control;
    }

    public void run() {
        this.control.run();
    }
}
```

Congratuations!! you finish third practice. Looks simple, right.

### Practice 4

In this practice, we will try to run the program in the YARN cluster. 

The overview steps are:
- Install hadoop cluster
- Package code to `jar` file.
- Run the MapReduce program with script.

#### Install hadoop cluster
Check the [sequenceiq/hadoop-docker](https://github.com/sequenceiq/hadoop-docker) to install hadoop docker container in local and test with sample code

In order to mount volume we used below script to start container:
```
docker run -v /path/to/project/folder:/datatraining -it sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
```

#### Package code to `jar` file
Before we package all the code and dependencies into jar file. we need to add plugin `maven-assembly-plugin` in the `pom.xml` file. check the code below:

```xml
           <plugin>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>3.1.0</version>
                <configuration>
                    <descriptorRefs>
                        <descriptorRef>jar-with-dependencies</descriptorRef>
                    </descriptorRefs>
                </configuration>
                <executions>
                    <execution>
                        <id>make-assembly</id> <!-- this is used for inheritance merges -->
                        <phase>package</phase> <!-- bind to the packaging phase -->
                        <goals>
                            <goal>single</goal>
                        </goals>
                    </execution>
                </executions>
          </plugin>
```

Then we need to make the hadoop related dependency to provided, the dependencies looks like below:
```xml
 <dependencies>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-common</artifactId>
            <version>3.0.1</version>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-client</artifactId>
            <version>3.0.1</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>
```
Also, we need to make the complier version as jdk 1.8, which set with below code:
```xml
<properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
</properties>
```

Then we run `mvn package` inside of project folder. after running success we will see `data-training-1.0-SNAPSHOT-jar-with-dependencies.jar` inside of the **target** folder.

#### Run the MapReduce program
- Use below script to put the **sample.txt** into HDFS
```
cd $HADOOP_PREFIX && bin/hadoop dfs -put /datatraining/src/main/resources/sample.txt /
```
- Use below scripts to run the MapReduce program
```
cd $HADOOP_PREFIX && bin/hadoop jar /datatraining/target/data-training-1.0-SNAPSHOT-jar-with-dependencies.jar com.practice.mapreduce.ChainDriver /sample.txt /tmoutput /finaloutput
```
- you can also use below command to run wordcount first
```
cd $HADOOP_PREFIX && bin/hadoop jar /datatraining/target/data-training-1.0-SNAPSHOT-jar-with-dependencies.jar com.practice.mapreduce.wordcount.WordCountDriver  /sample.txt /tmoutput
```

After finish we use the command below to verify the result
```
bin/hadoop dfs -cat /finaloutput/part-*
```
the result will looks like
```
a	24
you	14
of	16
local	17
to	23
the	44
```
If we use below command to list the part files
```
bin/hadoop dfs -ls /finaloutput/part-*
```
we will see the same partitions looks like runing in Intellij
```
-rw-r--r--   1 root supergroup          5 2018-07-29 08:47 /finaloutput/part-r-00000
-rw-r--r--   1 root supergroup         35 2018-07-29 08:47 /finaloutput/part-r-00001
```

Congratuations! you finish all the practice.
 
