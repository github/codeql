import swift

from BuiltinType t
// FPIEEE16 related stuff is not there on macOS
// FPIEEE80 is also missing on some CI runners
where
  not t.toString().matches("%FPIEEE16") and
  not t.toString().matches("%FPIEEE80")
select t, t.getPrimaryQlClasses()
