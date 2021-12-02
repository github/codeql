import java

// File classes should only be extracted if we need somewhere to
// put top-level members.
from Class c
where file_class(c)
  and not exists(c.getAMember())
  and none() // TODO: This is currently broken
select c
