class Range extends @range {
  string toString() { result = "" }
}

class Child extends @underscore_arg {
  string toString() { result = "" }
}

from Range range, Child end
where range_child(range, 1, end)
select range, end
