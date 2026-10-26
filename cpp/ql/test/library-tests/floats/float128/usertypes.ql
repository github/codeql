import cpp

from UserType t, Type related
where
  (
    related = t.(Class).getABaseClass() or
    related = t.(TypedefType).getUnderlyingType()
  ) and
  exists(t.getFile())
select t, related
