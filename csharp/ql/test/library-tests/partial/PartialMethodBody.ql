import csharp

private boolean hasBody(Method m) { if m.hasBody() then result = true else result = false }

from Method m
where m.fromSource() and m.isPartial()
select m, hasBody(m)
