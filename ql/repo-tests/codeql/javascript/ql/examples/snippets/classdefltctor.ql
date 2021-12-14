/**
 * @id js/examples/classdefltctor
 * @name Classes with a default constructor
 * @description Finds classes that do not declare an explicit constructor
 * @tags class
 *       constructor
 *       default constructor
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from ClassDefinition c
where c.getConstructor().isSynthetic()
select c
