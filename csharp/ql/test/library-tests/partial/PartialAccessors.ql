import csharp

private boolean isPartial(Accessor a) { if a.isPartial() then result = true else result = false }

from Accessor a
where a.fromSource()
select a, isPartial(a)
