import default

from CatchClause cc, UnionTypeAccess uta
where
  cc.isMultiCatch() and
  uta = cc.getVariable().getTypeAccess()
select cc, uta.getAnAlternative(), uta.getType().toString()
