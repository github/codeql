/**
 * @id py/examples/generator
 * @name Generator functions
 * @description Finds generator functions
 * @tags generator
 *       function
 */

import python

from Function f
where f.isGenerator()
select f
