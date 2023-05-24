/**
 * @name Missing part of special group in regular expression
 * @description Incomplete special groups are parsed as normal groups and are unlikely to match the intended strings.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision high
 * @id py/regex/incomplete-special-group
 */

import python
import semmle.python.regex

from RegExp r, string missing, string part
where r.getText().regexpMatch(".*\\(P<\\w+>.*") and missing = "?" and part = "named group"
select r, "Regular expression is missing '" + missing + "' in " + part + "."
