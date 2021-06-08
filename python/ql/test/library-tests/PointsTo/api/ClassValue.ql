import python

from ClassValue cls, string description
where
  cls = ClassValue::bool() and description = "bool"
  or
  cls = ClassValue::int_() and description = "int"
  or
  cls = ClassValue::float_() and description = "float"
  or
  cls = ClassValue::classmethod() and description = "classmethod"
  or
  cls = ClassValue::bool().getMro().getItem(2) and description = "object"
select cls, description
