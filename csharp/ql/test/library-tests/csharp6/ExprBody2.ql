/**
 * @name Tests expression-bodied methods
 */

import csharp

from Method m
select m, m.getExpressionBody()
