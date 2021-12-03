// Generated automatically from javax.servlet.annotation.ServletSecurity for testing purposes

package javax.servlet.annotation;

import java.lang.annotation.Annotation;
import javax.servlet.annotation.HttpConstraint;

public interface ServletSecurity extends Annotation
{
    HttpConstraint value();
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
