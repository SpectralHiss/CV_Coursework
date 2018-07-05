/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author hef30
 */
import java.util.Iterator;
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class NASDAQReducer extends Reducer<Text,IntWritable,Text,IntWritable> {
    
    public void reduce(Text key,Iterable<IntWritable> partialCounts, Context context) throws InterruptedException, IOException {
        Iterator<IntWritable> vals = partialCounts.iterator();
        
        int sum =0;
        if (vals.hasNext()){
            sum+= (vals.next()).get();
        }
        
        context.write(key, new IntWritable(sum));
    }    
}
