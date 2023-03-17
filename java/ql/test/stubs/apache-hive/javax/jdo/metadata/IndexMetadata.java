// Generated automatically from javax.jdo.metadata.IndexMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PropertyMetadata;

public interface IndexMetadata extends Metadata
{
    ColumnMetadata newColumn();
    ColumnMetadata[] getColumns();
    FieldMetadata newFieldMetadata(String p0);
    IndexMetadata setName(String p0);
    IndexMetadata setTable(String p0);
    IndexMetadata setUnique(boolean p0);
    MemberMetadata[] getMembers();
    PropertyMetadata newPropertyMetadata(String p0);
    String getName();
    String getTable();
    boolean getUnique();
    int getNumberOfColumns();
    int getNumberOfMembers();
}
