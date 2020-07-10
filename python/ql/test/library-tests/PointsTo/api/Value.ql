import python

from Value val, string name
where
  val = Value::named(name) and
  (
    name = "bool" or
    name = "sys" or
    name = "sys.argv" or
    name = "ValueError" or
    name = "slice"
  )
select val, name
