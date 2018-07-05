package Q3P1;

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
import java.util.regex.*;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.ArrayList;


import java.net.URI;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;

public class CW1TopMentionsMapper extends Mapper<LongWritable, Text, Text,IntWritable> {
      ArrayList<String> athletes;


      IntWritable one = new IntWritable(1);

      Text mentionedAthlete = new Text();

     protected void setup(Context context) throws IOException, InterruptedException {

        athletes = new ArrayList<String>();

        URI fileUri = context.getCacheFiles()[0];

        FileSystem fs = FileSystem.get(context.getConfiguration());
        FSDataInputStream in = fs.open(new Path(fileUri));

        BufferedReader br = new BufferedReader(new InputStreamReader(in));

        String line = "";
        try {
            // we discard the header row
            br.readLine();

            while ((line = br.readLine()) != null) {

                String[] fields = line.split(",");
                if(fields.length == 11){
                  athletes.add(fields[1].toLowerCase());
                }
             
            }
            br.close();
        } catch (IOException e1) {
        }

        super.setup(context);
    }


    public void map(LongWritable key , Text line, Context context )  throws IOException, InterruptedException {
      String[] fields = line.toString().split(";");
        
          String tweet;

          if (fields.length == 4) { 
            tweet = fields[2];
          } else {
            return;
          }
     
          for(String athlete : athletes) {
              if (tweet.contains(athlete)){
                 context.write(new Text(athlete), one);  
              }
          } 
	      
	    } 
    
}