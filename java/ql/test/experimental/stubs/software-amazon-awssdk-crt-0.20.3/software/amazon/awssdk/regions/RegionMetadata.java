// Generated automatically from software.amazon.awssdk.regions.RegionMetadata for testing purposes

package software.amazon.awssdk.regions;

import software.amazon.awssdk.regions.PartitionMetadata;
import software.amazon.awssdk.regions.Region;

public interface RegionMetadata
{
    PartitionMetadata partition();
    String description();
    String domain();
    String id();
    static RegionMetadata of(Region p0){ return null; }
}
