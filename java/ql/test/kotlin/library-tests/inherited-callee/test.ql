import java

from MethodCall ma, Callable callee, RefType declaringType
where ma.getCallee() = callee and callee.getDeclaringType() = declaringType
select ma, callee.toString(), declaringType.toString()
