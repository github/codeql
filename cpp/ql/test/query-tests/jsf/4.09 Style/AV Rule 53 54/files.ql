import cpp

string describe(File f) {
  f instanceof CFile and
  result = "CFile"
  or
  f instanceof CppFile and
  result = "CppFile"
  or
  f instanceof HeaderFile and
  result = "HeaderFile"
}

from File f
select f, concat(describe(f), ", ")
