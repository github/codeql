class Range extends @range {
  string toString() { result = "" }
}

class Child extends @underscore_arg {
  string toString() { result = "" }
}

from Range range, Child begin
where range_child(range, 0, begin)
select range, begin
