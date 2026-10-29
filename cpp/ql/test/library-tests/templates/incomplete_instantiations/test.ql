import cpp

from Class c, Function f
where
  c = f.getDeclaringType() and
  exists(f.getLocation())
select c, f, count(Stmt s | s.getEnclosingFunction() = f)
