// Generated automatically from jakarta.servlet.annotation.ServletSecurity for testing purposes

package jakarta.servlet.annotation;

import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.HttpMethodConstraint;
import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Documented
@Inherited
@Retention(value=java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value={java.lang.annotation.ElementType.TYPE})
public @interface ServletSecurity
{
    HttpConstraint value();
    HttpMethodConstraint[] httpMethodConstraints();
    static public enum EmptyRoleSemantic
    {
        DENY, PERMIT;
        private EmptyRoleSemantic() {}
    }
    static public enum TransportGuarantee
    {
        CONFIDENTIAL, NONE;
        private TransportGuarantee() {}
    }
}
