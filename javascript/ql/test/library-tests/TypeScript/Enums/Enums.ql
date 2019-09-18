import javascript

from EnumDeclaration enum, int n, string constness, string ambience, string exportedness
where
  (if enum.isConst() then constness = "const" else constness = "") and
  (if enum.isAmbient() then ambience = "ambient" else ambience = "") and
  (
    if exists(ExportNamedDeclaration ed | enum = ed.getOperand())
    then exportedness = "exported"
    else exportedness = ""
  )
select enum, enum.getIdentifier(), exportedness, constness, ambience, n, enum.getNumMember(),
  enum.getMember(n)
