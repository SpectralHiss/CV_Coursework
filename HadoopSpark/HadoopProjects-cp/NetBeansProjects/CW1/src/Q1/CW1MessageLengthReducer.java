package Q1;


/**
 *
 * @author hef30
 */
import java.util.Iterator;
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class CW1MessageLengthReducer extends Reducer<IntWritable,IntWritable,IntWritable,IntWritable> {
    
    public void reduce(IntWritable key,Iterable<IntWritable> partialCounts, Context context) throws InterruptedException, IOException {

      	int sum =0;
     
        for (IntWritable val : partialCounts) {
               sum += val.get();
        }
        
        context.write(key, new IntWritable(sum));
    }    
}
