import swift

string describe(Decl d) {
  d instanceof EnumDecl and result = "(EnumDecl)"
  or
  d instanceof EnumCaseDecl and result = "(EnumCaseDecl)"
  or
  d instanceof EnumElementDecl and result = "(EnumElementDecl)"
  or
  result = ".getType = " + d.(EnumDecl).getType().toString()
  or
  result = ".getDeclaringDecl = " + d.getDeclaringDecl().toString()
  or
  exists(int i |
    result = ".getElement(" + i.toString() + ") = " + d.(EnumCaseDecl).getElement(i).toString()
    or
    result = ".getParam(" + i.toString() + ") = " + d.(EnumElementDecl).getParam(i).toString()
    or
    result = ".getEnumElement(" + i.toString() + ") = " + d.(EnumDecl).getEnumElement(i).toString()
  )
}

from Decl d
where d.getLocation().getFile().getName() != ""
select d, strictconcat(describe(d), ", ")
