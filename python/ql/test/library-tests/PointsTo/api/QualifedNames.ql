import python

from FunctionValue v, string name
where
  name = v.getQualifiedName() and
  (
    v = Value::named("len")
    or
    v instanceof PythonFunctionValue
    or
    v = Value::named("sys.exit")
    or
    v = Value::named("list").(ClassValue).lookup("append")
  )
select v, name
