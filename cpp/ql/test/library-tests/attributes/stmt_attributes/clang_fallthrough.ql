import cpp

from Stmt s, StdAttribute a
where
  s.getASuccessor() instanceof SwitchCase and
  a = s.getAnAttribute() and
  a.hasQualifiedName("clang", "fallthrough")
select s, a.getLocation().toString()
