import cpp

string attributeArg(Attribute a) {
  if exists(a.getAnArgument()) then result = a.getAnArgument().toString() else result = "<none>"
}

from Attribute a
select a, attributeArg(a)
