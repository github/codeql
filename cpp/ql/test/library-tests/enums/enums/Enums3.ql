import cpp

string describe(Enum e) {
  e instanceof LocalEnum and
  result = "LocalEnum"
  or
  e instanceof NestedEnum and
  result = "NestedEnum"
  or
  e instanceof ScopedEnum and
  result = "ScopedEnum"
}

from Enum e
select e, concat(describe(e), ", ")
