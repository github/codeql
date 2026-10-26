// Generated automatically from javax.jdo.metadata.VersionMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.VersionStrategy;
import javax.jdo.metadata.ColumnMetadata;
import javax.jdo.metadata.IndexMetadata;
import javax.jdo.metadata.Indexed;
import javax.jdo.metadata.Metadata;

public interface VersionMetadata extends Metadata
{
    ColumnMetadata newColumnMetadata();
    ColumnMetadata[] getColumns();
    IndexMetadata getIndexMetadata();
    IndexMetadata newIndexMetadata();
    Indexed getIndexed();
    String getColumn();
    VersionMetadata setColumn(String p0);
    VersionMetadata setIndexed(Indexed p0);
    VersionMetadata setStrategy(VersionStrategy p0);
    VersionStrategy getStrategy();
    int getNumberOfColumns();
}
