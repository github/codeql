/**
 * @name Guards comparison test
 * @description List comparison parts.
 * @kind test
 */

import cpp
import semmle.code.cpp.controlflow.IRGuards

Element clearConversions(Element e) {
  if e instanceof Conversion
  then result = e.(Conversion).getExpr*()
  else result = e
}

from IRGuardCondition guard, Instruction left, Instruction right, int k, string which, string op, string msg
where 
(exists(boolean sense | sense = true and which = "true" or sense = false and which = "false" |
    guard.comparesLt(left, right, k, true, sense) and op = " < "
    or
    guard.comparesLt(left, right, k, false, sense) and op = " >= "
    or
    guard.comparesEq(left, right, k, true, sense) and op = " == "
    or 
    guard.comparesEq(left, right, k, false, sense)  and op = " != "
 )
)
and msg = clearConversions(left.getAST()) + op + clearConversions(right.getAST()) + "+" + k + " when " + clearConversions(guard.getAST()) + " is " + which

select guard.getLocation().getStartLine(), msg