import python

from Value val, string name
where
  val = Value::named(name) and
  name in ["bool", "sys", "sys.argv", "ValueError", "slice"]
select val, name
