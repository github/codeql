/**
 * INTERNAL: Do not use.
 *
 * Provides helper predicates for pretty-printing `DataFlow::Node`s.
 *
 * Since these have not been performance optimized, please only use them for
 * debug-queries or in tests.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DataFlowPrivate

/**
 * INTERNAL: Do not use.
 *
 * Gets the pretty-printed version of the Expr `e`.
 */
string prettyExpr(Expr e) {
  not e instanceof Num and
  not e instanceof StringLiteral and
  not e instanceof Subscript and
  not e instanceof Call and
  not e instanceof Attribute and
  result = e.toString()
  or
  result = e.(Num).getN()
  or
  result =
    e.(StringLiteral).getPrefix() + e.(StringLiteral).getText() +
      e.(StringLiteral).getPrefix().regexpReplaceAll("[a-zA-Z]+", "")
  or
  result = prettyExpr(e.(Subscript).getObject()) + "[" + prettyExpr(e.(Subscript).getIndex()) + "]"
  or
  (
    if exists(e.(Call).getAnArg()) or exists(e.(Call).getANamedArg())
    then result = prettyExpr(e.(Call).getFunc()) + "(..)"
    else result = prettyExpr(e.(Call).getFunc()) + "()"
  )
  or
  result = prettyExpr(e.(Attribute).getObject()) + "." + e.(Attribute).getName()
}

/**
 * INTERNAL: Do not use.
 *
 * Gets the pretty-printed version of the DataFlow::Node `node`
 */
bindingset[node]
string prettyNode(DataFlow::Node node) {
  if exists(node.asExpr()) then result = prettyExpr(node.asExpr()) else result = node.toString()
}

/**
 * INTERNAL: Do not use.
 *
 * Gets the pretty-printed version of the DataFlow::Node `node`, that is suitable for use
 * with `utils.test.InlineExpectationsTest` (that is, no spaces unless required).
 */
bindingset[node]
string prettyNodeForInlineTest(DataFlow::Node node) {
  result = prettyExpr(node.asExpr())
  or
  exists(Expr e | e = node.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() |
    // since PostUpdateNode both has space in the `[post <thing>]` annotation, and does
    // not pretty print the pre-update node, we do custom handling of this.
    result = "[post]" + prettyExpr(e)
  )
  or
  exists(Expr e | e = node.(DataFlowPrivate::SyntheticPreUpdateNode).getPostUpdateNode().asExpr() |
    result = "[pre]" + prettyExpr(e)
  )
  or
  not exists(node.asExpr()) and
  not exists(node.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()) and
  not exists(node.(DataFlowPrivate::SyntheticPreUpdateNode).getPostUpdateNode().asExpr()) and
  result = node.toString()
}
