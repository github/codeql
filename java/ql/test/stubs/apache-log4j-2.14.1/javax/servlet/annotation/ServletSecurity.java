// Generated automatically from javax.servlet.annotation.ServletSecurity for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import javax.servlet.annotation.HttpConstraint;
import javax.servlet.annotation.HttpMethodConstraint;

public interface ServletSecurity extends Annotation
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
