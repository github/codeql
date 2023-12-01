// Generated automatically from javax.servlet.annotation.HttpConstraint for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import javax.servlet.annotation.ServletSecurity;

@Documented
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
public @interface HttpConstraint
{
    ServletSecurity.EmptyRoleSemantic value();
    ServletSecurity.TransportGuarantee transportGuarantee();
    String[] rolesAllowed();
}
