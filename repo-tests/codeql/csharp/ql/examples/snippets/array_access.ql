/**
 * @id cs/examples/array-access
 * @name Array access
 * @description Finds array access expressions with an index expression
 *              consisting of a unary increment or decrement, e.g. 'a[i++]'.
 * @tags array
 *       access
 *       index
 *       unary
 *       assignment
 */

import csharp

from ArrayAccess a
where a.getAnIndex() instanceof MutatorOperation
select a
