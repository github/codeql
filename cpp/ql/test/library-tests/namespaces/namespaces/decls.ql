import cpp

string qual(Declaration d) {
  if exists(d.getQualifiedName())
  then result = d.getQualifiedName()
  else result = "<none>"
}

from Namespace n, Declaration d
where n = d.getNamespace()
select n, d, qual(d)

