// Generated automatically from javax.servlet.annotation.HttpMethodConstraint for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import javax.servlet.annotation.ServletSecurity;

public interface HttpMethodConstraint extends Annotation
{
    ServletSecurity.EmptyRoleSemantic emptyRoleSemantic();
    ServletSecurity.TransportGuarantee transportGuarantee();
    String value();
    String[] rolesAllowed();
}
