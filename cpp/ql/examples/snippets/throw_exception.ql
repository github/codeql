/**
 * @id cpp/examples/throw-exception
 * @name Throw exception of type
 * @description Finds places where we throw `parse_error` or one of its sub-types
 * @tags base
 *       class
 *       throw
 *       exception
 */

import cpp

from ThrowExpr throw
where throw.getType().(Class).getABaseClass*().getName() = "parse_error"
select throw
