import cpp

from Variable v, Type t, string qlClass, string const, string static
where
  t = v.getType() and
  qlClass = v.getAQlClass() and
  (qlClass.matches("%Variable%") or qlClass.matches("%Field%")) and
  (if v.isConst() then const = "const" else const = "") and
  if v.isStatic() then static = "static" else static = ""
select v, t, qlClass, const, static
