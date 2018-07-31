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
