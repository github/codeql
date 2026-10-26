// Generated automatically from javax.jdo.metadata.ClassMetadata for testing purposes

package javax.jdo.metadata;

import java.lang.reflect.Field;
import javax.jdo.metadata.ClassPersistenceModifier;
import javax.jdo.metadata.FieldMetadata;
import javax.jdo.metadata.TypeMetadata;

public interface ClassMetadata extends TypeMetadata
{
    ClassMetadata setPersistenceModifier(ClassPersistenceModifier p0);
    ClassPersistenceModifier getPersistenceModifier();
    FieldMetadata newFieldMetadata(Field p0);
    FieldMetadata newFieldMetadata(String p0);
}
