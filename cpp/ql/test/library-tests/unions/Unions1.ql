import cpp

string describe(Class c) {
  c instanceof Struct and
  result = "Struct"
  or
  c instanceof Union and
  result = "Union"
  or
  c instanceof LocalUnion and
  result = "LocalUnion"
  or
  c instanceof NestedUnion and
  result = "NestedUnion"
}

from Class c
select c, concat(describe(c), ", "), concat(c.getABaseClass().toString(), ", "),
  concat(c.getAMemberFunction().toString(), ", ")
