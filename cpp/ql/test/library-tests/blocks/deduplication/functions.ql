import cpp

from int line
select line, strictcount(Function f | f.getLocation().getStartLine() = line)
