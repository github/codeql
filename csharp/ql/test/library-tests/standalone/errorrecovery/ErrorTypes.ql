import csharp

from Variable v
where v.fromSource()
select v, v.getType().toString()
