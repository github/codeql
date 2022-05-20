import csharp

from LocalVariable v
where v.getType().hasName("Class")
select v, v.getType()
