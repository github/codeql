/**
 * @name Unmatchable caret in regular expression
 * @description Regular expressions containing a caret '^' in the middle cannot be matched, whatever the input.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @id py/regex/unmatchable-caret
 */

import python
import semmle.python.regex

predicate unmatchable_caret(RegExp r, int start) {
  not r.getAMode() = "MULTILINE" and
  not r.getAMode() = "VERBOSE" and
  r.specialCharacter(start, start + 1, "^") and
  not r.firstItem(start, start + 1)
}

from RegExp r, int offset
where unmatchable_caret(r, offset)
select r,
  "This regular expression includes an unmatchable caret at offset " + offset.toString() + "."
