// Generated automatically from javax.jdo.metadata.PrimaryKeyMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.Metadata;

public interface PrimaryKeyMetadata extends Metadata
{
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    PrimaryKeyMetadata setColumn(String p0);
    PrimaryKeyMetadata setName(String p0);
    String getColumn();
    String getName();
    int getNumberOfColumns();
}
