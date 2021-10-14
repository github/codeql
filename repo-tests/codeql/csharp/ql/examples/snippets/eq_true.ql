/**
 * @id cs/examples/eq-true
 * @name Equality test on Boolean
 * @description Finds tests like 'x==true', 'x==false', 'x!=true', '!=false'.
 * @tags equals
 *       test
 *       boolean
 */

import csharp

from EqualityOperation eq
where eq.getAnOperand() instanceof BoolLiteral
select eq
