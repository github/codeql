/**
 * @name Tests expression-bodied indexer
 */

import csharp

from Indexer i
select i, i.getExpressionBody()
