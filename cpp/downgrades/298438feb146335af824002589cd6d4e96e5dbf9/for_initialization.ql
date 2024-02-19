class Stmt extends @stmt {
  string toString() { none() }
}

from Stmt f, Stmt i
where
  for_initialization(f, i) and
  f instanceof @stmt_for
select f, i
