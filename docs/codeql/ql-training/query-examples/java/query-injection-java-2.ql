import java

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m and
  isStringConcat(ma.getArgument(0))
select ma, m
