
import java.io.IOException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author hef30
 */

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class NASDAQMapper extends Mapper<LongWritable, Text, Text,IntWritable> {
    
    Text stockName = new Text();
    IntWritable one = new IntWritable(1);
    
    public void map(LongWritable key , Text line, Context context )  throws IOException, InterruptedException {
        String[] fields = line.toString().split(",");
        
        stockName.set(fields[1]);
        context.write(stockName, one);
    }
}
