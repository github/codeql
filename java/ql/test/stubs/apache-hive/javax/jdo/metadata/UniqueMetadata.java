// Generated automatically from javax.jdo.metadata.UniqueMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PropertyMetadata;

public interface UniqueMetadata extends Metadata
{
    Boolean getDeferred();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    FieldMetadata newFieldMetadata(String p0);
    MemberMetadata[] getMembers();
    PropertyMetadata newPropertyMetadata(String p0);
    String getName();
    String getTable();
    UniqueMetadata setDeferred(boolean p0);
    UniqueMetadata setName(String p0);
    UniqueMetadata setTable(String p0);
    int getNumberOfColumns();
    int getNumberOfMembers();
}
