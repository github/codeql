// Generated automatically from javax.jdo.metadata.DatastoreIdentityMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.Metadata;

public interface DatastoreIdentityMetadata extends Metadata
{
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    DatastoreIdentityMetadata setColumn(String p0);
    DatastoreIdentityMetadata setCustomStrategy(String p0);
    DatastoreIdentityMetadata setSequence(String p0);
    DatastoreIdentityMetadata setStrategy(IdGeneratorStrategy p0);
    IdGeneratorStrategy getStrategy();
    String getColumn();
    String getCustomStrategy();
    String getSequence();
    int getNumberOfColumns();
}
