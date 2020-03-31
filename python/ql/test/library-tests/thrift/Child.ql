import external.Thrift

from ThriftElement t, int n
select t, n, t.getChild(n)
