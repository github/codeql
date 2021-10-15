import cpp

string describe(Declaration d) {
  d instanceof Variable and
  result = "Variable"
  or
  d instanceof Function and
  result = "Function"
}

from DeclStmt ds, Declaration d
where ds.getADeclaration() = d
select ds, concat(d.getName(), ", "), concat(describe(d), ", ")
