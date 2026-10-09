/**
 * @name Regex Global Flag in Test Function
 * @description When using the global flag (g) with regex in JavaScript, the test function
 *              may return inconsistent results (true or false) across multiple calls.
 *              This is due to the regex maintaining its last index position between calls.
 *              This behavior can lead to unexpected bugs, especially in validation scenarios.
 * @kind problem
 * @problem.severity error
 * @security-severity 6
 * @precision medium
 * @id js/regex-global-flag-issue
 * @tags javascript
 *       regex
 *       cwe-020
 *       global-flag
 *       testing
 *       bug
 */

import javascript

from RegExpLiteral re, CallExpr call, VariableAccess va
where
  re.getFlags().regexpMatch("g") and
  call.getCalleeName() = "test" and
  call.getArgument(0) = va
select re, "This call to " + call + " uses a regular expression with a global flag."
