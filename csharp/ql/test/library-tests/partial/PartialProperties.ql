import csharp

private boolean isPartial(Property p) { if p.isPartial() then result = true else result = false }

from Property p
where p.fromSource()
select p, isPartial(p)
