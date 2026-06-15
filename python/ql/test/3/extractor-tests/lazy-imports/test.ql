import python

string lazy(Stmt s) {
  if s.(Import).isLazy() or s.(ImportStar).isLazy() then result = "lazy" else result = "normal"
}

from Stmt s
where
  s.getLocation().getFile().getShortName() = "test.py" and
  (s instanceof Import or s instanceof ImportStar)
select s.getLocation().getStartLine(), s.toString(), lazy(s)
