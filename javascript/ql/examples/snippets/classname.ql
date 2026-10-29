/**
 * @id js/examples/classname
 * @name Classes called 'File'
 * @description Finds classes called 'File'
 * @tags class
 *       name
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from ClassDefinition cd
where cd.getName() = "File"
select cd
