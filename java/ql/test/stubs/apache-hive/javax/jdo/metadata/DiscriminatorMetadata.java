// Generated automatically from javax.jdo.metadata.DiscriminatorMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.DiscriminatorStrategy;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Indexed;
import javax.jdo.metadata.Metadata;

public interface DiscriminatorMetadata extends Metadata
{
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    DiscriminatorMetadata setColumn(String p0);
    DiscriminatorMetadata setIndexed(Indexed p0);
    DiscriminatorMetadata setStrategy(DiscriminatorStrategy p0);
    DiscriminatorMetadata setValue(String p0);
    DiscriminatorStrategy getStrategy();
    IndexMetadata getIndexMetadata();
    IndexMetadata newIndexMetadata();
    Indexed getIndexed();
    String getColumn();
    String getValue();
    int getNumberOfColumns();
}
