class Function extends @function {
  string toString() { none() }
}

from Function f
where functions(f, _, 6)
select f
