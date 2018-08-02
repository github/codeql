import javascript

from VarAccess access
where access.getVariable().getScope() instanceof EnumScope
select access, access.analyze().ppTypes()
