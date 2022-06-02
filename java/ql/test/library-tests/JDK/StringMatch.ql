import java

from MethodAccess ma, StringPartialMatchMethod m
where ma.getMethod() = m
select ma, ma.getArgument(m.getMatchParameterIndex())
