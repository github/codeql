class Function extends @function {
  string toString() { none() }
}

from Function fun, string name, int kind, int kind_new
where
  functions(fun, name, kind) and
  if kind = 7 or kind = 8 then kind_new = 0 else kind_new = kind
select fun, name, kind_new
