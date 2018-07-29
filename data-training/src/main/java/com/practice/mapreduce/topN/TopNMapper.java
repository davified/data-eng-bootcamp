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
        this.top_n = context.getConfiguration().getInt("top.n", 5);
    }


    @Override
    public void map(Text key, Text value, Context context) {
        int count = Integer.parseInt(value.toString());
        String word = key.toString();
        resultMap.put(count, word);
        if (resultMap.size() > this.top_n) {
            resultMap.pollFirstEntry();
        }
    }


    @Override
    public void cleanup(Context context) throws IOException, InterruptedException {
        for (int count : resultMap.keySet()) {
            IntWritable value = new IntWritable(count);
            Text key = new Text(resultMap.get(count));
            context.write(key, value);
        }
    }
}
