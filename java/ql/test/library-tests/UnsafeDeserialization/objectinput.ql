import default
import semmle.code.java.security.UnsafeDeserialization

from ObjectInputStreamReadObjectMethod m, MethodAccess ma
where ma.getMethod() = m
select ma, m.getDeclaringType().getName()
