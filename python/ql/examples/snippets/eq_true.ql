/**
 * @id py/examples/eq-true
 * @name Equality test on boolean
 * @description Finds tests like `==true`, `==false`, `"!=true`, `is false`
 * @tags equals
 *       test
 *       boolean
 */

import python

from Compare eq
where eq.getAComparator() instanceof BooleanLiteral
select eq
