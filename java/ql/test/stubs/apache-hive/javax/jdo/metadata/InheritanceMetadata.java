// Generated automatically from javax.jdo.metadata.InheritanceMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.InheritanceStrategy;
import javax.jdo.metadata.DiscriminatorMetadata;
import javax.jdo.metadata.JoinMetadata;
import javax.jdo.metadata.Metadata;

public interface InheritanceMetadata extends Metadata
{
    DiscriminatorMetadata getDiscriminatorMetadata();
    DiscriminatorMetadata newDiscriminatorMetadata();
    InheritanceMetadata setCustomStrategy(String p0);
    InheritanceMetadata setStrategy(InheritanceStrategy p0);
    InheritanceStrategy getStrategy();
    JoinMetadata getJoinMetadata();
    JoinMetadata newJoinMetadata();
    String getCustomStrategy();
}
