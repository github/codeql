/**
 * @name Builtin objects
 * @description Finds expressions that refer to an object in the builtins module (like int or None).
 * @tags reference
 *       builtin
 *       object
 */
 
import python

from Expr e
where e.refersTo(builtin_object(_))
select e
