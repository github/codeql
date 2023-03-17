// Generated automatically from javax.jdo.metadata.OrderMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Metadata;

public interface OrderMetadata extends Metadata
{
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    IndexMetadata getIndexMetadata();
    IndexMetadata newIndexMetadata();
    OrderMetadata setColumn(String p0);
    OrderMetadata setMappedBy(String p0);
    String getColumn();
    String getMappedBy();
    int getNumberOfColumns();
}
