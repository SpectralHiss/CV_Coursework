package Q3P2;

/**
 *
 * @author hef30
 */
import java.util.Iterator;
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class CW1TopSportsReducer extends Reducer<Text,IntWritable,Text,IntWritable> {
    
    public void reduce(Text hashTag,Iterable<IntWritable> partialCounts, Context context) throws InterruptedException, IOException {
       	
       	int sum = 0; 
        for (IntWritable val : partialCounts) {
               sum += val.get();
        }
        context.write(hashTag, new IntWritable(sum));
    }    
}
