import cpp

// Some structs have multiple definitions, but those definitions use different
// (but compatible) field types.  With this query we can check getType() always
// returns a single result.
from Struct s, MemberVariable mv, int i, Type t, string types
where
  mv = s.getAMember(i) and
  t = mv.getType() and
  types = count(mv.getType()) + " types"
select s, i, t, types
