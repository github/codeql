import cpp

// Some structs have multiple definitions, but those definitions use different
// (but compatible) field types.  With this query we can check getType() always
// returns a single result.
from Class c, MemberVariable mv, int i, Type t, string types
where
  mv = c.getAMember(i) and
  t = mv.getType() and
  types = count(mv.getType()) + " types"
select c, i, t, types
