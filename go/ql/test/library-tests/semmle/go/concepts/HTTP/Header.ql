import go

from HTTP::HeaderWrite headerWrite, string name, string value, string definedName, string definedVal
where
  (
    name = headerWrite.getName().toString()
    or
    not exists(headerWrite.getName()) and name = "n/a"
  ) and
  (
    value = headerWrite.getValue().toString()
    or
    not exists(headerWrite.getValue()) and value = "n/a"
  ) and
  (
    headerWrite.definesHeader(definedName, definedVal)
    or
    not headerWrite.definesHeader(_, _) and
    definedName = "n/a" and
    definedVal = "n/a"
  )
select headerWrite, name, value, definedName, definedVal
