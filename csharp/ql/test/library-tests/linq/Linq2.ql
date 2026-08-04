/**
 * @name Test for Linq expressions
 */

import csharp

from BinaryOperation e
where not e instanceof Assignment
select e, e.getAnOperand()
