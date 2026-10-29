// Generated automatically from javax.jdo.metadata.FetchPlanMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.FetchGroupMetadata;
import javax.jdo.metadata.Metadata;

public interface FetchPlanMetadata extends Metadata
{
    FetchGroupMetadata newFetchGroupMetadata(String p0);
    FetchGroupMetadata[] getFetchGroups();
    FetchPlanMetadata setFetchSize(int p0);
    FetchPlanMetadata setMaxFetchDepth(int p0);
    String getName();
    int getFetchSize();
    int getMaxFetchDepth();
    int getNumberOfFetchGroups();
}
