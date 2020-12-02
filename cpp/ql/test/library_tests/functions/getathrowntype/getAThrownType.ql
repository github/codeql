import cpp

string describe(Function f) {
  f.isNoThrow() and
  result = "isNoThrow"
  or
  f.isNoExcept() and
  result = "isNoExcept"
}

from Function f
where exists(f.getFile())
select f, concat(f.getAThrownType().toString(), ", "), concat(describe(f), ", ")
