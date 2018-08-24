import cpp

from Variable v, Class t
where t = v.getType().(PointerType).getBaseType()
select v, t, count(t.getAMember())
