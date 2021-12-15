import external.Thrift

from string cls
where any(ThriftElement t).getAQlClass() = cls
select cls.prefix(6)
