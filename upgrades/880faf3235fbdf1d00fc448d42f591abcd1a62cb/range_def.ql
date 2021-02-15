class Range extends @range {
  string toString() { result = "" }
}

class Parent extends @ast_node_parent {
  string toString() { result = "" }
}

class Location extends @location {
  string toString() { result = "" }
}

from Range range, Parent parent, int parentIndex, int operatorKind, Location loc
where
  range_def(range, parent, parentIndex, loc) and
  operatorKind = 0 // best we can do is assume it was .. and not ...
select range, parent, parentIndex, operatorKind, loc
