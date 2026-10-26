import python

from ImportExpr ie, string m, string t, string r
where
  m = ie.getImportedModuleName() and
  (if ie.isTop() then t = "top" else t = "bottom") and
  (if ie.isRelative() then r = "relative" else r = "absolute")
select ie.getScope().toString(), ie.getLocation().getStartLine(), ie.toString(), ie.getLevel(), t,
  r, m
