/**
 * @name Tests expression-bodied methods
 */

import csharp

from Method m
where m.fromSource()
select m, m.getExpressionBody()
