import java.sql.DatabaseMetaData;
import java.util.List;
import org.apache.hadoop.hive.metastore.api.ColumnStatistics;
import org.apache.hadoop.hive.metastore.api.DefaultConstraintsRequest;
import org.apache.hadoop.hive.metastore.ObjectStore;
import org.apache.hive.hcatalog.templeton.HcatDelegator;
import org.apache.hive.hcatalog.templeton.ColumnDesc;

public class Test {
    public static Object source() {
        return null;
    }

    public void test(DatabaseMetaData dmd) throws Exception {
        String taint = (String) source();
        // java.sql;DatabaseMetaData;true;getColumns;(String,String,String,String);;Argument[2];sql;ai-generated
        dmd.getColumns("", "", taint, ""); // $ sqlInjection
        // java.sql;DatabaseMetaData;true;getPrimaryKeys;(String,String,String);;Argument[2];sql;ai-generated
        dmd.getPrimaryKeys("", "", taint); // $ sqlInjection
    }

    public void test(ObjectStore objStore, HcatDelegator hcatDel) throws Exception {
        {
            String taint = (String) source();
            // "org.apache.hadoop.hive.metastore.api;DefaultConstraintsRequest;true;DefaultConstraintsRequest;(String,String,String);;Argument[1];sql;ai-generated"
            new DefaultConstraintsRequest("", taint, ""); // $ sqlInjection
        }
        {
            ColumnStatistics taint = (ColumnStatistics) source();
            // "org.apache.hadoop.hive.metastore;ObjectStore;true;updatePartitionColumnStatistics;(ColumnStatistics,List,String,long);;Argument[0];sql;ai-generated"
            // @formatter:off
            // objStore.updatePartitionColumnStatistics(taint, (List<String>) null, (String) null, 0L); // $ sqlInjection
            // @formatter:on
            // "org.apache.hadoop.hive.metastore;ObjectStore;true;updatePartitionColumnStatistics;(ColumnStatistics,List);;Argument[0];sql;ai-generated"
            objStore.updatePartitionColumnStatistics(taint, (List<String>) null); // $ sqlInjection
        }
        {
            ColumnDesc taint = (ColumnDesc) source();
            // "org.apache.hive.hcatalog.templeton;HcatDelegator;true;addOneColumn;(String,String,String,ColumnDesc);;Argument[3];sql;ai-generated"
            hcatDel.addOneColumn(null, null, null, taint); // $ sqlInjection
        }
    }
}
