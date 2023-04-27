// Generated automatically from javax.jdo.metadata.SequenceMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.SequenceStrategy;
import javax.jdo.metadata.Metadata;

public interface SequenceMetadata extends Metadata
{
    Integer getAllocationSize();
    Integer getInitialValue();
    SequenceMetadata setAllocationSize(int p0);
    SequenceMetadata setDatastoreSequence(String p0);
    SequenceMetadata setFactoryClass(String p0);
    SequenceMetadata setInitialValue(int p0);
    SequenceStrategy getSequenceStrategy();
    String getDatastoreSequence();
    String getFactoryClass();
    String getName();
}
