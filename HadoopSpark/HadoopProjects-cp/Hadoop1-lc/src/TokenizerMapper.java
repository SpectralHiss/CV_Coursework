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
import java.util.StringTokenizer;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class TokenizerMapper extends Mapper<Object, Text, IntWritable, IntWritable> { 
    private final IntWritable one = new IntWritable(1);
    private IntWritable wordlength = new IntWritable();
    public void map(Object key, Text value, Context context) throws IOException, InterruptedException {
        StringTokenizer itr = new StringTokenizer(value.toString(), "-- \t\n\r\f,.:;?![]'\"");
        
        
        
        while (itr.hasMoreTokens()) {
          String data1 = itr.nextToken();
          
          int length = data1.length();
          wordlength.set(length);
          context.write(wordlength, one);
          }
          
        }
    }