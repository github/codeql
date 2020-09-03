import java
import semmle.code.java.dataflow.SignAnalysis

string getASignString(Expr i) {
  positive(i) and
  result = "positive"
  or
  negative(i) and
  result = "negative"
  or
  strictlyPositive(i) and
  result = "strictlyPositive"
  or
  strictlyNegative(i) and
  result = "strictlyNegative"
}

from Expr e
select e, strictconcat(string s | s = getASignString(e) | s, " ")
