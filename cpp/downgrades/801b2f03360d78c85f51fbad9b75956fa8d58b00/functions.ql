class Function extends @function {
  string toString() { none() }
}

from Function f, string n, int k, int new_k
where
  functions(f, n, k) and
  if builtin_functions(f) then new_k = 6 else new_k = k
select f, n, new_k
