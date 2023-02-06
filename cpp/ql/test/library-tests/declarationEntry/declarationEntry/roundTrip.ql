import cpp

from DeclarationEntry de, Declaration d, string canRoundTrip
where
  d = de.getDeclaration() and
  if d.getADeclarationEntry() = de then canRoundTrip = "yes" else canRoundTrip = "no"
select de, d, canRoundTrip
