import csharp

from DelegateType t
where t.getAnnotatedReturnType().isRef()
select t
