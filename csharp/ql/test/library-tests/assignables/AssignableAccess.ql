import csharp

from AssignableAccess aa, Assignable a, string s
where
  aa.getTarget() = a and
  a.fromSource() and
  (
    aa instanceof AssignableRead and s = "read"
    or
    aa instanceof AssignableWrite and s = "write"
  )
select aa, a, s
