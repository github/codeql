import default
import semmle.code.java.security.UnsafeDeserializationQuery

from Method m, MethodAccess ma
where ma.getMethod() = m and unsafeDeserialization(ma, _)
select ma, m.getDeclaringType().getName()
