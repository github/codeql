/**
 * @name Asserting a tuple
 * @description Using an assert statement to test a tuple provides no validity checking.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       external/cwe/cwe-670
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/asserts-tuple
 */

import python

from Assert a, string b, string non
where
  a.getTest() instanceof Tuple and
  (
    if exists(a.getTest().(Tuple).getAnElt())
    then (
      b = "True" and non = "non-"
    ) else (
      b = "False" and non = ""
    )
  )
select a, "Assertion of " + non + "empty tuple is always " + b + "."
