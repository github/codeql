import external.Thrift

from ThriftFunction t, string n, ThriftElement x
where
  exists(int i | x = t.getArgument(i) and n = i.toString())
  or
  x = t.getAThrows() and n = "throws"
  or
  x = t.getReturnType() and n = "returns"
select t, n, x
