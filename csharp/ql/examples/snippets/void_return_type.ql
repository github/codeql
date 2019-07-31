/**
 * @id cs/examples/void-return-type
 * @name Methods without return type
 * @description Finds methods whose return type is 'void'.
 * @tags method
 *       void
 *       modifier
 *       return
 *       type
 */

import csharp

from Method m
where m.getReturnType() instanceof VoidType
select m
