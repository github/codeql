import java

from Class c, Member m
where
  c.hasQualifiedName("", "Tst") and
  c.getAMember() = m and
  m instanceof @field
select m
