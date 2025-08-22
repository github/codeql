import csharp

from Method m
where m.fromSource()
select m, count(m.getBody())
