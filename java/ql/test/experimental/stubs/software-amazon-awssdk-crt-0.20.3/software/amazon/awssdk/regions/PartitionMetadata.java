// Generated automatically from software.amazon.awssdk.regions.PartitionMetadata for testing purposes

package software.amazon.awssdk.regions;

import software.amazon.awssdk.regions.PartitionEndpointKey;
import software.amazon.awssdk.regions.Region;

public interface PartitionMetadata
{
    String id();
    String name();
    String regionRegex();
    default String dnsSuffix(){ return null; }
    default String dnsSuffix(PartitionEndpointKey p0){ return null; }
    default String hostname(){ return null; }
    default String hostname(PartitionEndpointKey p0){ return null; }
    static PartitionMetadata of(Region p0){ return null; }
    static PartitionMetadata of(String p0){ return null; }
}
