// Generated automatically from javax.sql.DataSource for testing purposes

package javax.sql;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ConnectionBuilder;
import java.sql.Wrapper;
import javax.sql.CommonDataSource;

public interface DataSource extends CommonDataSource, Wrapper
{
    Connection getConnection();
    Connection getConnection(String p0, String p1);
    PrintWriter getLogWriter();
    default ConnectionBuilder createConnectionBuilder(){ return null; }
    int getLoginTimeout();
    void setLogWriter(PrintWriter p0);
    void setLoginTimeout(int p0);
}
