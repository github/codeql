/**
 * @name Unmatchable dollar in regular expression
 * @description Regular expressions containing a dollar '$' in the middle cannot be matched, whatever the input.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/regex/unmatchable-dollar
 */

import python
import semmle.python.regex

predicate unmatchable_dollar(RegExp r, int start) {
  not r.getAMode() = "MULTILINE" and
  not r.getAMode() = "VERBOSE" and
  r.specialCharacter(start, start + 1, "$") and
  not r.lastItem(start, start + 1)
}

from RegExp r, int offset
where unmatchable_dollar(r, offset)
select r,
  "This regular expression includes an unmatchable dollar at offset " + offset.toString() + "."
