import cpp

from File f, int line
select f, line, strictcount(Expr e | e.getFile() = f and e.getLocation().getStartLine() = line)
