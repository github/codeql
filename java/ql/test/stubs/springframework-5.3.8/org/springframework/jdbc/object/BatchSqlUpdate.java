// Generated automatically from org.springframework.jdbc.object.BatchSqlUpdate for testing purposes

package org.springframework.jdbc.object;

import javax.sql.DataSource;
import org.springframework.jdbc.object.SqlUpdate;

public class BatchSqlUpdate extends SqlUpdate
{
    protected boolean supportsLobParameters(){ return false; }
    public BatchSqlUpdate(){}
    public BatchSqlUpdate(DataSource p0, String p1){}
    public BatchSqlUpdate(DataSource p0, String p1, int[] p2){}
    public BatchSqlUpdate(DataSource p0, String p1, int[] p2, int p3){}
    public int getExecutionCount(){ return 0; }
    public int getQueueCount(){ return 0; }
    public int update(Object... p0){ return 0; }
    public int[] flush(){ return null; }
    public int[] getRowsAffected(){ return null; }
    public static int DEFAULT_BATCH_SIZE = 0;
    public void reset(){}
    public void setBatchSize(int p0){}
    public void setTrackRowsAffected(boolean p0){}
}
