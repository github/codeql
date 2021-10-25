import csharp
import semmle.code.csharp.dataflow.SignAnalysis

string getASignString(ControlFlow::Nodes::ExprNode e) {
  positive(e) and
  not strictlyPositive(e) and
  result = "positive"
  or
  negative(e) and
  not strictlyNegative(e) and
  result = "negative"
  or
  strictlyPositive(e) and
  result = "strictlyPositive"
  or
  strictlyNegative(e) and
  result = "strictlyNegative"
}

from ControlFlow::Nodes::ExprNode e
where not e.getExpr().fromLibrary()
select e, strictconcat(string s | s = getASignString(e) | s, " ")
