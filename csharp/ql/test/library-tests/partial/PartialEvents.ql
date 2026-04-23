import csharp

private boolean isPartial(Event e) { if e.isPartial() then result = true else result = false }

from Event e
where e.fromSource()
select e, isPartial(e)
