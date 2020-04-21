import external.Thrift

from ThriftNamedElement t
select t.getName(), t.getFile().getBaseName()
