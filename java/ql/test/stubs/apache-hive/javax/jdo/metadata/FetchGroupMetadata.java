// Generated automatically from javax.jdo.metadata.FetchGroupMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.MemberMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.PropertyMetadata;

public interface FetchGroupMetadata extends Metadata
{
    Boolean getPostLoad();
    FetchGroupMetadata setPostLoad(boolean p0);
    FieldMetadata newFieldMetadata(String p0);
    MemberMetadata[] getMembers();
    PropertyMetadata newPropertyMetadata(String p0);
    String getName();
    int getNumberOfMembers();
}
