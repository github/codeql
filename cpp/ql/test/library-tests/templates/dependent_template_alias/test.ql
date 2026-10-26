import cpp

from Variable v, Class c
where
  c = v.getType() and
  v.getFile().getBaseName() = "test.cpp"
select v, c, c.getAMemberVariable()
