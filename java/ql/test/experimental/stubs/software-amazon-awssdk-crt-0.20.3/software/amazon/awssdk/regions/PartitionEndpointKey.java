// Generated automatically from software.amazon.awssdk.regions.PartitionEndpointKey for testing purposes

package software.amazon.awssdk.regions;

import java.util.Collection;
import java.util.Set;
import software.amazon.awssdk.regions.EndpointTag;

public class PartitionEndpointKey
{
    protected PartitionEndpointKey() {}
    public Set<EndpointTag> tags(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static PartitionEndpointKey.Builder builder(){ return null; }
    static public interface Builder
    {
        PartitionEndpointKey build();
        PartitionEndpointKey.Builder tags(Collection<EndpointTag> p0);
        PartitionEndpointKey.Builder tags(EndpointTag... p0);
    }
}
