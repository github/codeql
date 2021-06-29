import python
import semmle.python.dataflow.new.DataFlow

string prettyExpr(Expr e) {
  not e instanceof Num and
  not e instanceof StrConst and
  not e instanceof Subscript and
  not e instanceof Call and
  not e instanceof Attribute and
  result = e.toString()
  or
  result = e.(Num).getN()
  or
  result =
    e.(StrConst).getPrefix() + e.(StrConst).getText() +
      e.(StrConst).getPrefix().regexpReplaceAll("[a-zA-Z]+", "")
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
 * Gets pretty-printed version of the DataFlow::Node `node`
 */
bindingset[node]
string prettyNode(DataFlow::Node node) {
  if exists(node.asExpr()) then result = prettyExpr(node.asExpr()) else result = node.toString()
}

/**
 * Gets pretty-printed version of the DataFlow::Node `node`, that is suitable for use
 * with `TestUtilities.InlineExpectationsTest` (that is, no spaces unless required).
 */
bindingset[node]
string prettyNodeForInlineTest(DataFlow::Node node) {
  exists(node.asExpr()) and
  result = prettyExpr(node.asExpr())
  or
  exists(Expr e | e = node.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() |
    // since PostUpdateNode both has space in the `[post <thing>]` annotation, and does
    // not pretty print the pre-update node, we do custom handling of this.
    result = "[post]" + prettyExpr(e)
  )
  or
  not exists(node.asExpr()) and
  not exists(Expr e | e = node.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()) and
  result = node.toString()
}
