package Q2P1;

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
import java.time.*;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CW1TweetsInHourMapper extends Mapper<LongWritable, Text, IntWritable,IntWritable> {
    
    IntWritable hourInDay = new IntWritable();
    IntWritable one = new IntWritable(1);
    
    public void map(LongWritable key , Text line, Context context )  throws IOException, InterruptedException {
        String[] fields = line.toString().split(";");
       	long tweetTimeEpoch;
       	
        // filter malformed records
       	if (fields.length == 4) {
       		try { 
        	tweetTimeEpoch = new Long(fields[0]);
        	// ignore other kind of malformed tweets)
  			  } catch (NumberFormatException e) {
  				  return ;
  			  }
  		  } else {
  			 return ;
  		  }

        int tweetHourInDay = ZonedDateTime.ofInstant(Instant.ofEpochSecond(tweetTimeEpoch),  ZoneId.of("Brazil/East")).getHour();
  		  hourInDay.set(tweetHourInDay);
        context.write(hourInDay, one);
	}
}
