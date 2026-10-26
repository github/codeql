import cpp

string describe(UsingEntry ue) {
  ue instanceof UsingDeclarationEntry and
  result = "UsingDeclarationEntry"
  or
  ue instanceof UsingDirectiveEntry and
  result = "UsingDirectiveEntry"
  or
  result = "enclosingElement:" + ue.getEnclosingElement().toString()
}

from UsingEntry ue
select ue, concat(describe(ue), ", ")
