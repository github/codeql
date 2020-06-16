import python
import external.Thrift

from ThriftType t, ThriftStruct s
where t.references(s)
select t, s
