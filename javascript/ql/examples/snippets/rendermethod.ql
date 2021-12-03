/**
 * @id js/examples/rendermethod
 * @name Methods named 'render'
 * @description Finds methods named 'render'
 * @tags class
 *       method
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from MethodDefinition m
where m.getName() = "render"
select m
