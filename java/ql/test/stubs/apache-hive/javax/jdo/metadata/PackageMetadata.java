// Generated automatically from javax.jdo.metadata.PackageMetadata for testing purposes

package javax.jdo.metadata;

import javax.jdo.annotations.SequenceStrategy;
import javax.jdo.metadata.ClassMetadata;
import javax.jdo.metadata.InterfaceMetadata;
import javax.jdo.metadata.Metadata;
import javax.jdo.metadata.SequenceMetadata;

public interface PackageMetadata extends Metadata
{
    ClassMetadata newClassMetadata(Class p0);
    ClassMetadata newClassMetadata(String p0);
    ClassMetadata[] getClasses();
    InterfaceMetadata newInterfaceMetadata(Class p0);
    InterfaceMetadata newInterfaceMetadata(String p0);
    InterfaceMetadata[] getInterfaces();
    PackageMetadata setCatalog(String p0);
    PackageMetadata setSchema(String p0);
    SequenceMetadata newSequenceMetadata(String p0, SequenceStrategy p1);
    SequenceMetadata[] getSequences();
    String getCatalog();
    String getName();
    String getSchema();
    int getNumberOfClasses();
    int getNumberOfInterfaces();
    int getNumberOfSequences();
}
