import javascript

from LocalVariable v, DataFlow::CallNode nd
where
  nd = AngularJS::moduleRef(_) and
  nd.flowsToExpr(v.getAnAssignedExpr())
select v
