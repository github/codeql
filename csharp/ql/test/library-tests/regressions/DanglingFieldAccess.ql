import csharp

from FieldAccess access
where not exists(access.getTarget())
select access.getParent()
