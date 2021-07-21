private import python
private import semmle.python.ApiGraphs

predicate isEmptyOrNone(DataFlow::Node arg) { isEmpty(arg) or isNone(arg) }

predicate isEmpty(DataFlow::Node arg) {
  exists(StrConst emptyString |
    emptyString.getText() = "" and
    DataFlow::exprNode(emptyString).(DataFlow::LocalSourceNode).flowsTo(arg)
  )
}

predicate isNone(DataFlow::Node arg) {
  exists( | DataFlow::exprNode(any(None no)).(DataFlow::LocalSourceNode).flowsTo(arg))
}

predicate isFalse(DataFlow::Node arg) {
  exists( | DataFlow::exprNode(any(False falseExpr)).(DataFlow::LocalSourceNode).flowsTo(arg))
}

