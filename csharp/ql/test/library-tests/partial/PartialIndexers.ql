import csharp

private boolean isPartial(Indexer i) { if i.isPartial() then result = true else result = false }

from Indexer i
where i.fromSource()
select i, isPartial(i)
