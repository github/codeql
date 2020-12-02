import cpp

from Type t, string s
where
  // Filter out a couple of types that only appear on some platforms
  not t.toString() = "__va_list_tag" and
  not t.toString() = "void *" and
  if exists(t.getUnspecifiedType()) then s = t.getUnspecifiedType().toString() else s = "<none>"
select t, s
