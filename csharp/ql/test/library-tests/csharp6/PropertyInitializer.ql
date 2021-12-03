/**
 * @name Tests property initializers
 */

import csharp

from Property p
select p, p.getInitializer()
