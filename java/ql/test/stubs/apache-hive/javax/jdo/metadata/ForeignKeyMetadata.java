// Generated automatically from javax.jdo.metadata.ForeignKeyMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.ForeignKeyAction;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PropertyMetadata;

public interface ForeignKeyMetadata extends Metadata
{
    Boolean getDeferred();
    Boolean getUnique();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    FieldMetadata newFieldMetadata(String p0);
    ForeignKeyAction getDeleteAction();
    ForeignKeyAction getUpdateAction();
    ForeignKeyMetadata setDeferred(boolean p0);
    ForeignKeyMetadata setDeleteAction(ForeignKeyAction p0);
    ForeignKeyMetadata setName(String p0);
    ForeignKeyMetadata setTable(String p0);
    ForeignKeyMetadata setUnique(boolean p0);
    ForeignKeyMetadata setUpdateAction(ForeignKeyAction p0);
    MemberMetadata[] getMembers();
    PropertyMetadata newPropertyMetadata(String p0);
    String getName();
    String getTable();
    int getNumberOfColumns();
    int getNumberOfMembers();
}
