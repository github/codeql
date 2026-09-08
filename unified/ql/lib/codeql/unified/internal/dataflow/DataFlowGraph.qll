private import unified
private import AllDataFlow

predicate step(Node node1, Step step, Node node2) {
  exists(BinaryExpr expr |
    expr.getOperator().getValue() = "+" and
    node1.isResultValue([expr.getLeft(), expr.getRight()]) and
    step.taint() and
    node2.isResultValue(expr)
  )
  or
  exists(TupleExpr expr, int i |
    node1.isResultValue(expr.getElement(i).getValue()) and
    step.storeName(i.toString()) and
    node2.isResultValue(expr)
  )
  or
  exists(MemberAccessExpr expr |
    node1.isResultValue(expr.getBase()) and
    step.readName(expr.getMemberName()) and
    node2.isResultValue(expr)
  )
  or
  none() // Temporarily disable compilation errors from unsatisfiable types
}
