import java

from Method m, MethodCall ma
where
  m.getName().matches("sparql%Query") and
  ma.getMethod() = m
select ma, m
