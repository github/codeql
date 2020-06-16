/**
 * @id py/examples/builtin-object
 * @name Builtin objects
 * @description Finds expressions that refer to an object in the builtins module (like int or None).
 * @tags reference
 *       builtin
 *       object
 */

import python

from Expr e, string name
where e.pointsTo(Value::named(name)) and not name.charAt(_) = "."
select e
