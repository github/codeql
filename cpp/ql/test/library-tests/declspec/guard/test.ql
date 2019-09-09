import cpp

// What we select here isn't too important; we're just testing the
// __declspec(guard(...)) attributes don't cause extractor errors.
from Function f, string p, int n
where
  if f.getNumberOfParameters() = 0
  then p = "<none>" and n = -1
  else p = f.getParameter(n).toString()
select f, n, p
