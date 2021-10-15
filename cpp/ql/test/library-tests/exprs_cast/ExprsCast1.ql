/**
 * @name ExprsCast1
 * @kind table
 */

import cpp

from Cast c
select c, count(c.getExpr())
