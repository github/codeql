/**
 * @id cpp/examples/toomanyparams
 * @name Functions with many parameters
 * @description Finds functions or methods with more than 10 parameters
 * @tags function
 *       method
 *       parameter
 *       argument
 */

import cpp

from Function fcn
where fcn.getNumberOfParameters() > 10
select fcn
