import csharp

from TypeAccess access, TupleType type
where type = access.getTarget()
select access, type
