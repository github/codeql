// Generated automatically from javax.sql.CommonDataSource for testing purposes

package javax.sql;

import java.io.PrintWriter;
import java.sql.ShardingKeyBuilder;
import java.util.logging.Logger;

public interface CommonDataSource
{
    Logger getParentLogger();
    PrintWriter getLogWriter();
    default ShardingKeyBuilder createShardingKeyBuilder(){ return null; }
    int getLoginTimeout();
    void setLogWriter(PrintWriter p0);
    void setLoginTimeout(int p0);
}
