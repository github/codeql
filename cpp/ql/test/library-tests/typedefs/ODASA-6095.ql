import cpp

from TypedefType t
where not exists(t.getBaseType().getUnspecifiedType())
select t.getUnspecifiedType(), t.getUnspecifiedType().getFile()
