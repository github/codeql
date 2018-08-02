import javascript

from Express::RouterDefinition r, ControlFlowNode nd
select r, nd, r.getMiddlewareStackAt(nd)
