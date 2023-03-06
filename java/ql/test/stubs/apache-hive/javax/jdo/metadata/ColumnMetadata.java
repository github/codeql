// Generated automatically from javax.jdo.metadata.ColumnMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.Metadata;

public interface ColumnMetadata extends Metadata
{
    Boolean getAllowsNull();
    ColumnMetadata setAllowsNull(boolean p0);
    ColumnMetadata setDefaultValue(String p0);
    ColumnMetadata setInsertValue(String p0);
    ColumnMetadata setJDBCType(String p0);
    ColumnMetadata setLength(int p0);
    ColumnMetadata setName(String p0);
    ColumnMetadata setPosition(int p0);
    ColumnMetadata setSQLType(String p0);
    ColumnMetadata setScale(int p0);
    ColumnMetadata setTarget(String p0);
    ColumnMetadata setTargetField(String p0);
    Integer getLength();
    Integer getPosition();
    Integer getScale();
    String getDefaultValue();
    String getInsertValue();
    String getJDBCType();
    String getName();
    String getSQLType();
    String getTarget();
    String getTargetField();
}
