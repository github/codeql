// Generated automatically from javax.servlet.annotation.ServletSecurity for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.servlet.annotation.HttpConstraint;
import javax.servlet.annotation.HttpMethodConstraint;

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
