/**
 * @id java/examples/nativemethod
 * @name Native methods
 * @description Finds methods that are native
 * @tags method
 *       native
 *       modifier
 */

import java

from Method m
where m.isNative()
select m
