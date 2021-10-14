/**
 * @id js/examples/generator
 * @name Generator functions
 * @description Finds generator functions
 * @tags generator
 *       function
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from Function f
where f.isGenerator()
select f
