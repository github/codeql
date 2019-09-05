import cpp

Namespace topLevelNamespace(Declaration d) { result.getADeclaration() = d }

from Declaration d, string tl, string ns
where
  d.getFile().toString() != "" and
  (if exists(topLevelNamespace(d)) then tl = topLevelNamespace(d).toString() else tl = "NONE") and
  (if exists(d.getNamespace()) then ns = d.getNamespace().toString() else ns = "NONE")
select d, tl, ns
