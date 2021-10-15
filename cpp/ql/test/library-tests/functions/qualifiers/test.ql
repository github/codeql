import cpp

from SpecifiedType t, boolean b
where if t.isConst() then b = true else b = false
select t, b
