/**
 * @id js/examples/evenness
 * @name Tests for even numbers
 * @description Finds expressions of the form `e % 2 === 0`
 * @tags arithmetic
 *       modulo
 *       comparison
 *       even
 */

import javascript

from StrictEqExpr eq, ModExpr mod, NumberLiteral zero, NumberLiteral two
where
  two.getValue() = "2" and
  mod.getRightOperand() = two and
  zero.getValue() = "0" and
  eq.hasOperands(mod, two)
select eq
