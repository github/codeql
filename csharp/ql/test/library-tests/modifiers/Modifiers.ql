import csharp

from Modifiable m
where m.fromSource()
select m, m.getAModifier()
