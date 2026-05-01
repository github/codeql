class BoolParent extends @py_bool_parent {
  string toString() { result = "BoolParent" }
}

// Drop py_bools rows for Import and ImportStar parents,
// since the old schema does not include them in @py_bool_parent.
from BoolParent parent, int idx
where
  py_bools(parent, idx) and
  not parent instanceof @py_Import and
  not parent instanceof @py_ImportStar
select parent, idx
