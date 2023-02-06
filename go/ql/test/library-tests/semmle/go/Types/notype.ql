import go

from Expr e
where
  // filter out expressions that don't have any semantics
  exists(DataFlow::exprNode(e)) and
  not type_of(e, _)
select e, e.getType()
