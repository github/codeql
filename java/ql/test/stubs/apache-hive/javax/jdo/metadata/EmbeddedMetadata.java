// Generated automatically from javax.jdo.metadata.EmbeddedMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.DiscriminatorMetadata;
import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PropertyMetadata;

public interface EmbeddedMetadata extends Metadata
{
    DiscriminatorMetadata getDiscriminatorMetadata();
    DiscriminatorMetadata newDiscriminatorMetadata();
    EmbeddedMetadata setNullIndicatorColumn(String p0);
    EmbeddedMetadata setNullIndicatorValue(String p0);
    EmbeddedMetadata setOwnerMember(String p0);
    FieldMetadata newFieldMetadata(String p0);
    MemberMetadata[] getMembers();
    PropertyMetadata newPropertyMetadata(String p0);
    String getNullIndicatorColumn();
    String getNullIndicatorValue();
    String getOwnerMember();
    int getNumberOfMembers();
}
