import csharp

private boolean isPartial(Method m) { if m.isPartial() then result = true else result = false }

from Method m
where m.fromSource()
select m, isPartial(m)
