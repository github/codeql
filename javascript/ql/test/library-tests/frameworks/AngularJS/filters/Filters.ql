import javascript

from AngularJS::FilterDefinition def, DataFlow::FunctionNode service, DataFlow::FunctionNode factory
where
  service = def.getAService() and
  factory = def.getAFactoryFunction()
select def, def.getName(), service.getName(), factory.getName()
