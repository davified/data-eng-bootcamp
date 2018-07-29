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
