/**
 * @id java/examples/toomanyparams
 * @name Methods with many parameters
 * @description Finds methods with more than ten parameters
 * @tags method
 *       parameter
 *       argument
 */

import java

from Method m
where m.getNumberOfParameters() > 10
select m
