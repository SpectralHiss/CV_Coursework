package Q1;

import java.io.IOException;


/**
 *
 * @author hef30
 */

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CW1MessageLengthMapper extends Mapper<LongWritable, Text, IntWritable,IntWritable> {
    
    int binWidth = 5;
    IntWritable histogramBin = new IntWritable();
    IntWritable one = new IntWritable(1);
    
    public void map(LongWritable key , Text line, Context context )  throws IOException, InterruptedException {
        String[] fields = line.toString().split(";");
       	
        String tweet;
       	if (fields.length == 4) { 

        tweet = fields[2];
    	} else {
    		return;
    	}
        int codePointsInTweet = tweet.codePointCount(0, tweet.length() );

        histogramBin.set((codePointsInTweet -1 ) / binWidth);
        context.write(histogramBin, one);
}
}
