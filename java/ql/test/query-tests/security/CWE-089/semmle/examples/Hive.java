import org.apache.hadoop.hive.metastore.api.ColumnStatistics;
import org.apache.hadoop.hive.metastore.api.DefaultConstraintsRequest;
import org.apache.hadoop.hive.metastore.ObjectStore;
import org.apache.hive.hcatalog.templeton.ColumnDesc;
import org.apache.hive.hcatalog.templeton.HcatDelegator;
import java.util.List;

public class Hive {

    public static Object source() {
        return null;
    }

    public void test(ObjectStore objStore, HcatDelegator hcatDel) throws Exception {
        {
            String taint = (String) source();
            new DefaultConstraintsRequest("", taint, ""); // $ sqlInjection
        }
        {
            ColumnStatistics taint = (ColumnStatistics) source();
            //objStore.updatePartitionColumnStatistics(taint, (List<String>) null, (String) null, 0L); // $ sqlInjection
            objStore.updatePartitionColumnStatistics(taint, (List<String>) null); // $ sqlInjection
        }
        {
            ColumnDesc taint = (ColumnDesc) source();
            hcatDel.addOneColumn(null, null, null, taint); // $ sqlInjection
        }
    }
}
