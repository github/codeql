import cpp

from Declaration d, DeclarationEntry de, int i, int j
where
  (d.getADeclarationEntry() = de or de.getDeclaration() = d) and
  (if d.getADeclarationEntry() = de then i = 1 else i = 0) and
  (if de.getDeclaration() = d then j = 1 else j = 0) and
  d.getLocation().getStartLine() != 0
select d, de, i as getADeclarationEntry, j as getDeclaration
