import cpp

from UserType t, Type related
where related = ((Class)t).getABaseClass()
   or related = ((TypedefType)t).getUnderlyingType()
select t, related
