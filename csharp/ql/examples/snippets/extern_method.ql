/**
 * @id cs/examples/extern-method
 * @name Extern methods
 * @description Finds methods that are 'extern'.
 * @tags method
 *       native
 *       modifier
 */

import csharp

from Method m
where m.isExtern()
select m
