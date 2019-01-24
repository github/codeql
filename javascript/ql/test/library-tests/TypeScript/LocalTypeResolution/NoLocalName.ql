import javascript

from LocalTypeAccess type
where not exists(type.getLocalTypeName())
select type, "has no local type name (which is ok)"
