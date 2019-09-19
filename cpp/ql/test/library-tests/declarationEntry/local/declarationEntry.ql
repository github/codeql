import cpp

from Element e, string s
where
  (
    e instanceof DeclarationEntry or
    e instanceof Declaration
  ) and
  e.getFile().toString() != "" and
  (if e.(TypeDeclarationEntry).isTopLevel() then s = "TopLevel" else s = "")
select e, s
