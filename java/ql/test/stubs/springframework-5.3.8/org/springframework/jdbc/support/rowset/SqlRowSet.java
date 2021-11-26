// Generated automatically from org.springframework.jdbc.support.rowset.SqlRowSet for testing purposes

package org.springframework.jdbc.support.rowset;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Map;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;

public interface SqlRowSet extends Serializable
{
    <T> T getObject(String p0, Class<T> p1);
    <T> T getObject(int p0, Class<T> p1);
    BigDecimal getBigDecimal(String p0);
    BigDecimal getBigDecimal(int p0);
    Date getDate(String p0);
    Date getDate(String p0, Calendar p1);
    Date getDate(int p0);
    Date getDate(int p0, Calendar p1);
    Object getObject(String p0);
    Object getObject(String p0, Map<String, Class<? extends Object>> p1);
    Object getObject(int p0);
    Object getObject(int p0, Map<String, Class<? extends Object>> p1);
    SqlRowSetMetaData getMetaData();
    String getNString(String p0);
    String getNString(int p0);
    String getString(String p0);
    String getString(int p0);
    Time getTime(String p0);
    Time getTime(String p0, Calendar p1);
    Time getTime(int p0);
    Time getTime(int p0, Calendar p1);
    Timestamp getTimestamp(String p0);
    Timestamp getTimestamp(String p0, Calendar p1);
    Timestamp getTimestamp(int p0);
    Timestamp getTimestamp(int p0, Calendar p1);
    boolean absolute(int p0);
    boolean first();
    boolean getBoolean(String p0);
    boolean getBoolean(int p0);
    boolean isAfterLast();
    boolean isBeforeFirst();
    boolean isFirst();
    boolean isLast();
    boolean last();
    boolean next();
    boolean previous();
    boolean relative(int p0);
    boolean wasNull();
    byte getByte(String p0);
    byte getByte(int p0);
    double getDouble(String p0);
    double getDouble(int p0);
    float getFloat(String p0);
    float getFloat(int p0);
    int findColumn(String p0);
    int getInt(String p0);
    int getInt(int p0);
    int getRow();
    long getLong(String p0);
    long getLong(int p0);
    short getShort(String p0);
    short getShort(int p0);
    void afterLast();
    void beforeFirst();
}
