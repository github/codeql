import csharp

private string getType(Setter s) { if s.isInitOnly() then result = "init" else result = "set" }

from Setter s
where s.fromSource()
select s, getType(s)
