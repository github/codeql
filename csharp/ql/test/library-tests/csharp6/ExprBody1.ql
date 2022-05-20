/**
 * @name Tests expression-bodied properties
 */

import csharp

from Property p
select p, p.getExpressionBody()
