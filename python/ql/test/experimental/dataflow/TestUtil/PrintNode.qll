import python
import semmle.python.dataflow.new.DataFlow

string prettyExp(Expr e) {
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
  result = prettyExp(e.(Subscript).getObject()) + "[" + prettyExp(e.(Subscript).getIndex()) + "]"
  or
  (
    if exists(e.(Call).getAnArg()) or exists(e.(Call).getANamedArg())
    then result = prettyExp(e.(Call).getFunc()) + "(..)"
    else result = prettyExp(e.(Call).getFunc()) + "()"
  )
  or
  result = prettyExp(e.(Attribute).getObject()) + "." + e.(Attribute).getName()
}

string prettyNode(DataFlow::Node node) {
  if exists(node.asExpr()) then result = prettyExp(node.asExpr()) else result = node.toString()
}
