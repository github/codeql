import javascript

from AngularJS::Controller c, DOM::ElementDefinition elem, string name
where
  c.boundTo(elem) and
  if not c.boundToAs(elem, _) then name = "-" else c.boundToAs(elem, name)
select c, elem, c.getFactoryFunction(), name
