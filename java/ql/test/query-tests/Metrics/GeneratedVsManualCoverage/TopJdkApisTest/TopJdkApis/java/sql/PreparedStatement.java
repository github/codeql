// Generated automatically from java.sql.PreparedStatement for testing purposes

package java.sql;

import java.io.InputStream;
import java.io.Reader;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Array;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.NClob;
import java.sql.ParameterMetaData;
import java.sql.Ref;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.RowId;
import java.sql.SQLType;
import java.sql.SQLXML;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;

public interface PreparedStatement extends Statement
{
    ResultSet executeQuery(); // manual neutral
    int executeUpdate(); // manual neutral
    void setInt(int p0, int p1); // manual neutral
    void setLong(int p0, long p1); // manual neutral
    void setString(int p0, String p1); // manual summary
}
