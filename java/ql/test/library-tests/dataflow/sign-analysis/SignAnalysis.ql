import java
import semmle.code.java.dataflow.SignAnalysis

string getASignString(Expr e) {
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

from Expr e
where e.getEnclosingCallable().fromSource()
select e, strictconcat(string s | s = getASignString(e) | s, " ")
