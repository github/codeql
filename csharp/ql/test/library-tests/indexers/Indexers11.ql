/**
 * @name Test for indexers
 */

import csharp

from Parameter p
select count(p.getDeclaringElement())
