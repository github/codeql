/**
 * @name Tests expression-bodied operators
 */

import csharp

from Operator op
where op.fromSource()
select op, op.getExpressionBody()
