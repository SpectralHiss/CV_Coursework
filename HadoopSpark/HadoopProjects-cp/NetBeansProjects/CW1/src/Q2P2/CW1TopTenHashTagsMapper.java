package Q2P2;

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
import java.util.regex.*;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class CW1TopTenHashTagsMapper extends Mapper<LongWritable, Text, Text,IntWritable> {
    
    int mostPopularHour = 23;
    IntWritable one = new IntWritable(1);
    Pattern p = Pattern.compile("#[\\w]+");

    Matcher m;
    Text hTag = new Text();

    public void map(LongWritable key , Text line, Context context )  throws IOException, InterruptedException {
      String[] fields = line.toString().split(";");
        
      String tweet;

      if (fields.length == 4) { 
        tweet = fields[2];
      } else {
        return;
      }
     
   	 	long tweetTimeEpoch;

      try { 
        tweetTimeEpoch = new Long(fields[0]);
        // ignore other kind of malformed tweets)
      } catch (NumberFormatException e) {
          return ;
      }
 		
   		int tweetHourInDay = ZonedDateTime.ofInstant(Instant.ofEpochSecond(tweetTimeEpoch),  ZoneId.of("Brazil/East")).getHour();
    		
    		if(tweetHourInDay!= mostPopularHour) {
    			return;
    		} else {

    			m = p.matcher(tweet);
          
  	        while(m.find()){
    	    		String hashTag = tweet.substring(m.start(),m.end());
    	    		hTag.set(hashTag);
    	    		context.write(hTag, one);	
  	        }
  	    } 
      }
}