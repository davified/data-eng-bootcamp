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
        this.topN = context.getConfiguration().getInt("top.n", 5);
    }

    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context) {
        int total = getTotalCount(values);
        resultMap.put(total, key.toString());
        if (resultMap.size() > topN) {
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

    private int getTotalCount(Iterable<IntWritable> values) {
        int sum = 0;
        for (IntWritable value : values) {
            sum += value.get();
        }
        return sum;
    }
}
