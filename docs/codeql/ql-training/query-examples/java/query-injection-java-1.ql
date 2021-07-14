import java

from Method m, MethodAccess ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m
select ma, m