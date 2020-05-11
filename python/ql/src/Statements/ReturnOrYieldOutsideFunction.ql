/**
 * @name Use of 'return' or 'yield' outside a function
 * @description Using 'return' or 'yield' outside a function causes a 'SyntaxError' at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity error
 * @sub-severity low
 * @precision medium
 * @id py/return-or-yield-outside-function
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
select node, "'" + kind + "' is used outside a function."
