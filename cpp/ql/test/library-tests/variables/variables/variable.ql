import cpp

string interestingQlClass(Variable v) {
  result = v.getAQlClass() and
  (
    result.contains("Variable")
    or
    result.contains("Field")
  )
}

from Variable v, Type t, string const, string static
where
  t = v.getType() and
  (if v.isConst() then const = "const" else const = "") and
  if v.isStatic() then static = "static" else static = ""
select v, t, concat(interestingQlClass(v), ", "), const, static
