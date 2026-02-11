// Generated automatically from jakarta.servlet.annotation.HttpMethodConstraint for testing purposes

package jakarta.servlet.annotation;

import jakarta.servlet.annotation.ServletSecurity;
import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
public @interface HttpMethodConstraint
{
    ServletSecurity.EmptyRoleSemantic emptyRoleSemantic();
    ServletSecurity.TransportGuarantee transportGuarantee();
    String value();
    String[] rolesAllowed();
}
