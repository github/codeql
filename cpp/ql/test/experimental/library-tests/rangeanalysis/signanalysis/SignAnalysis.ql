import experimental.semmle.code.cpp.rangeanalysis.SignAnalysis
import semmle.code.cpp.ir.IR

string getASignString(Instruction i) {
  positiveInstruction(i) and
  result = "positive"
  or
  negativeInstruction(i) and
  result = "negative"
  or
  strictlyPositiveInstruction(i) and
  result = "strictlyPositive"
  or
  strictlyNegativeInstruction(i) and
  result = "strictlyNegative"
}

from Instruction i
select i, strictconcat(string s | s = getASignString(i) | s, " ")
