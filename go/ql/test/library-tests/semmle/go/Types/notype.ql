import go

from Expr e
where
  // filter out expressions that don't have any semantics
  exists(DataFlow::exprNode(e)) and
  // no type was extracted for the expression, and it has no synthesized type either
  not type_of(e, _) and
  e.getType() instanceof InvalidType
select e, e.getType()
