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
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCountDriver.class);

        //input and output
        FileInputFormat.addInputPath(job, new Path(args[0]));
        Path outputDir = new Path(args[1]);
        FileOutputFormat.setOutputPath(job, outputDir);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(IntWritable.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        job.setMapperClass(WordCountMapper.class);
        job.setReducerClass(WordCountReducer.class);

        // this will improve the performance
        job.setCombinerClass(WordCountReducer.class);

        //delete the output dir
        outputDir.getFileSystem(conf).delete(outputDir);

        return job;
    }
}
