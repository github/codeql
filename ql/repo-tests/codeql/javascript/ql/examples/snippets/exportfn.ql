/**
 * @id js/examples/exportfn
 * @name Default exports exporting a function
 * @description Finds 'default' exports that export a function
 * @tags module
 *       export
 *       default export
 *       ECMAScript 6
 *       ECMAScript 2015
 */

import javascript

from ExportDefaultDeclaration e
where e.getOperand() instanceof Function
select e
