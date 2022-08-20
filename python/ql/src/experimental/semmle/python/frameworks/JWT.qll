private import python
private import semmle.python.ApiGraphs

/** Checks if the argument is empty or none. */
predicate isEmptyOrNone(DataFlow::Node arg) { isEmpty(arg) or isNone(arg) }

/** Checks if an empty string `""` flows to `arg` */
predicate isEmpty(DataFlow::Node arg) {
  exists(StrConst emptyString |
    emptyString.getText() = "" and
    DataFlow::exprNode(emptyString).(DataFlow::LocalSourceNode).flowsTo(arg)
  )
}

/** Checks if `None` flows to `arg` */
predicate isNone(DataFlow::Node arg) {
  DataFlow::exprNode(any(None no)).(DataFlow::LocalSourceNode).flowsTo(arg)
}

/** Checks if `False` flows to `arg` */
predicate isFalse(DataFlow::Node arg) {
  DataFlow::exprNode(any(False falseExpr)).(DataFlow::LocalSourceNode).flowsTo(arg)
}
