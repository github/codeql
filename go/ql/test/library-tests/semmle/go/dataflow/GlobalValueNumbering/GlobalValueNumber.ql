import go

from DataFlow::Node nd, Expr init
where
  (
    init instanceof BasicLit or
    init instanceof CompositeLit or
    init instanceof CallExpr or
    init = Builtin::true_().getAReference() or
    init = Builtin::false_().getAReference()
  ) and
  globalValueNumber(nd) = init.getGlobalValueNumber()
select nd, init
