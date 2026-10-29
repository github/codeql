// Generated automatically from javax.jdo.metadata.JoinMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.ForeignKeyAction;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.ForeignKeyMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Indexed;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PrimaryKeyMetadata;
import javax.jdo.metadata.UniqueMetadata;

public interface JoinMetadata extends Metadata
{
    Boolean getUnique();
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    ForeignKeyAction getDeleteAction();
    ForeignKeyMetadata getForeignKeyMetadata();
    ForeignKeyMetadata newForeignKeyMetadata();
    IndexMetadata getIndexMetadata();
    IndexMetadata newIndexMetadata();
    Indexed getIndexed();
    JoinMetadata setColumn(String p0);
    JoinMetadata setDeleteAction(ForeignKeyAction p0);
    JoinMetadata setIndexed(Indexed p0);
    JoinMetadata setOuter(boolean p0);
    JoinMetadata setTable(String p0);
    JoinMetadata setUnique(boolean p0);
    PrimaryKeyMetadata getPrimaryKeyMetadata();
    PrimaryKeyMetadata newPrimaryKeyMetadata();
    String getColumn();
    String getTable();
    UniqueMetadata getUniqueMetadata();
    UniqueMetadata newUniqueMetadata();
    boolean getOuter();
    int getNumberOfColumns();
}
