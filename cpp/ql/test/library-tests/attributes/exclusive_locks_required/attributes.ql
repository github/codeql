import cpp

string attribute(Function f) {
  if exists(f.getAnAttribute()) then result = f.getAnAttribute().toString() else result = "<none>"
}

from Function f
select f, attribute(f)
