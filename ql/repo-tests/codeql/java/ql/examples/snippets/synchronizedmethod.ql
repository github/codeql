/**
 * @id java/examples/synchronizedmethod
 * @name Synchronized methods
 * @description Finds methods that are synchronized
 * @tags method
 *       synchronized
 *       modifier
 */

import java

from Method m
where m.isSynchronized()
select m
