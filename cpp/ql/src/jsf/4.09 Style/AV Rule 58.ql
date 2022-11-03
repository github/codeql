/**
 * @name AV Rule 58
 * @description When declaring and defining functions with more than two parameters, the leading parenthesis and the first argument will be written on the same line as the function name. Each additional argument will be written on a separate line (with the closing parenthesis directly after the last argument).
 * @kind problem
 * @id cpp/jsf/av-rule-58
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

class ParamLoc extends Parameter {
  int getValidLine() {
    result = this.getLocation().getStartLine() and result = this.getLocation().getEndLine()
  }
}

predicate valid(Function f) {
  // Check that the first parameter is okay
  f.getParameter(0).(ParamLoc).getValidLine() = f.getLocation().getStartLine() and
  // Check that each subsequent parameter is on its own line
  not exists(ParamLoc p1, ParamLoc p2 |
    p1 = f.getAParameter() and
    p2 = f.getAParameter() and
    p1 != p2 and
    p1.getValidLine() = p2.getValidLine()
  ) and
  // Check that there are no parameters on two lines
  forall(ParamLoc p | p = f.getAParameter() | exists(p.getValidLine()))
}

from Function f
where
  f.getNumberOfParameters() > 2 and
  f.hasDefinition() and
  not valid(f)
select f,
  "AV Rule 58: functions with more than two parameters will conform to style rules for declaring parameters"
