/**
 * @name Tests expression-bodied operators
 */

import csharp

from Operator op
select op, op.getExpressionBody()
