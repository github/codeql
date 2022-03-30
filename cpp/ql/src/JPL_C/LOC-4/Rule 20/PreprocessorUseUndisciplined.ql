/**
 * @name Undisciplined macro
 * @description Macros are not allowed to use complex preprocessor features like variable argument lists and token pasting.
 * @kind problem
 * @id cpp/jpl-c/preprocessor-use-undisciplined
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

from Macro m, string msg
where
  m.getHead().matches("%...%") and
  msg = "The macro " + m.getHead() + " is variadic, and hence not allowed."
  or
  m.getBody().matches("%##%") and
  msg = "The macro " + m.getHead() + " uses token pasting and is not allowed."
select m, msg
