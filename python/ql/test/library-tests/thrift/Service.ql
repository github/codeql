import external.Thrift

from ThriftService service, string name
select service, name, service.getFunction(name)
