import swift

from BuiltinType t
// FPIEEE16 related stuff is not there on macOS
where not t.toString().matches("%FPIEEE16")
select t, t.getPrimaryQlClasses()
