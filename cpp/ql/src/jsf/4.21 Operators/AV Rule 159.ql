/**
 * @name AV Rule 159
 * @description Operators ||, &&, and unary & shall not be overloaded
 * @kind problem
 * @id cpp/jsf/av-rule-159
 * @problem.severity warning
 * @tags correctness
 *       external/jsf
 */

/*
 * See More Effective C++ item 7.
 * Note: Meyers allows unary `&` to be overloaded but not comma.
 */

import cpp

from Function o, string message
where
  o.getName() = "operator&&" and
  message =
    "AV Rule 159: the && operator shall not be overloaded as short-circuit semantics cannot be obtained."
  or
  o.getName() = "operator||" and
  message =
    "AV Rule 159: the || operator shall not be overloaded as short-circuit semantics cannot be obtained."
  or
  o.getName() = "operator&" and
  o.getNumberOfParameters() = 1 and
  message =
    "AV Rule 159: the unary & operator shall not be overloaded because of undefined behavior."
select o, message
