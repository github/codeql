import cpp

string functionType(Function f) {
  if exists(f.getParameter(_))
  then
    result =
      concat(int i | | f.getParameter(i).getType().toString(), " -> " order by i) + " -> " +
        f.getType().toString()
  else result = f.getType().toString()
}

from Function f, boolean b
where if f.isSideEffectFree() then b = true else b = false
select f, functionType(f), b
