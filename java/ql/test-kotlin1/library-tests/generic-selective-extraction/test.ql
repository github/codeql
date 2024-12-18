import java

from RefType rt, Member m
where
  rt.getSourceDeclaration().fromSource() and
  m.getDeclaringType() = rt
select rt, m
