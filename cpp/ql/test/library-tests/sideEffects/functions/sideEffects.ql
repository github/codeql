import cpp

string functionType(Function f, int i) {
  if exists(f.getParameter(i))
  then result = f.getParameter(i).getType().toString() + " -> " + functionType(f, i + 1)
  else (
    i = f.getNumberOfParameters() and result = f.getType().toString()
  )
}

from Function f, boolean b
where if f.isSideEffectFree() then b = true else b = false
select f, functionType(f, 0), b
