class Stmt extends @underscore_statement {
  string toString() { result = "" }
}

class Interpolation extends @interpolation {
  string toString() { result = "" }
}

// The new table adds an index column, so any interpolation_child tables in the
// old dbscheme were implicitly index 0.
from Interpolation interpolation, int index, Stmt child
where interpolation_child(interpolation, child) and index = 0
select interpolation, index, child
