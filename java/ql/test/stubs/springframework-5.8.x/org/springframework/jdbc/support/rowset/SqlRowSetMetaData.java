// Generated automatically from org.springframework.jdbc.support.rowset.SqlRowSetMetaData for testing purposes

package org.springframework.jdbc.support.rowset;


public interface SqlRowSetMetaData
{
    String getCatalogName(int p0);
    String getColumnClassName(int p0);
    String getColumnLabel(int p0);
    String getColumnName(int p0);
    String getColumnTypeName(int p0);
    String getSchemaName(int p0);
    String getTableName(int p0);
    String[] getColumnNames();
    boolean isCaseSensitive(int p0);
    boolean isCurrency(int p0);
    boolean isSigned(int p0);
    int getColumnCount();
    int getColumnDisplaySize(int p0);
    int getColumnType(int p0);
    int getPrecision(int p0);
    int getScale(int p0);
}
