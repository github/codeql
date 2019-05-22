/**
 * @name return or yield are used outside of a function
 * @description return and yield statements should be used only within a function.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/return-or-yield-outside-of-function
 */

import python

from AstNode node, string kind
where
  not node.getScope() instanceof Function and
  (
    node instanceof Return and kind = "return"
    or
    node instanceof Yield and kind = "yield"
    or
    node instanceof YieldFrom and kind = "yield from"
  )
select node, "'" + kind + "' is used outside of a function."
