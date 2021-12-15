import csharp

from Parameter p
where p.fromSource()
select p, p.getDefaultValue()
