/**
 * @id py/examples/too-many-params
 * @name Functions with many parameters
 * @description Finds functions with more than 7 parameters
 * @tags function
 *       parameter
 *       argument
 */

import python

from Function fcn
where count(fcn.getAnArg()) > 7
select fcn
