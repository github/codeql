// Generated automatically from javax.servlet.annotation.HttpConstraint for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import javax.servlet.annotation.ServletSecurity;

public interface HttpConstraint extends Annotation
{
    ServletSecurity.EmptyRoleSemantic value();
    ServletSecurity.TransportGuarantee transportGuarantee();
    String[] rolesAllowed();
}
