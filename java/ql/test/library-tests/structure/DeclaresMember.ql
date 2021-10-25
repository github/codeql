/**
 * @name DeclaresMember
 */

import default

from Type t, Member m
where
  m.getDeclaringType() = t and
  (t.fromSource() or t instanceof TypeObject)
select t.toString(), m.toString()
