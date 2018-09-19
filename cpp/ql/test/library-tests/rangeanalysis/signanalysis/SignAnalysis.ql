import semmle.code.cpp.rangeanalysis.SignAnalysis
import semmle.code.cpp.ir.IR

string getASignString(Instruction i) {
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

from Instruction i
select i, i.getAST(), strictconcat(string s | s = getASignString(i) | s, " ")