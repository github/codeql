// Generated automatically from java.sql.ResultSet for testing purposes

package java.sql;

import java.io.InputStream;
import java.io.Reader;
import java.math.BigDecimal;
import java.net.URL;
import java.sql.Array;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.NClob;
import java.sql.Ref;
import java.sql.ResultSetMetaData;
import java.sql.RowId;
import java.sql.SQLType;
import java.sql.SQLWarning;
import java.sql.SQLXML;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Wrapper;
import java.util.Calendar;
import java.util.Map;

public interface ResultSet extends AutoCloseable, Wrapper
{
    String getString(String p0); // manual summary
    String getString(int p0); // manual neutral
    Timestamp getTimestamp(String p0); // manual neutral
    boolean next(); // manual neutral
    int getInt(String p0); // manual neutral
    int getInt(int p0); // manual neutral
    long getLong(String p0); // manual neutral
}
