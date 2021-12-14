/**
 * @name Pointer nesting too high
 * @description No more than one level of pointer nesting/dereferencing should be used.
 * @kind problem
 * @id cpp/power-of-10/pointer-nesting
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/powerof10
 */

import cpp

from Variable v, int n
where n = v.getType().(PointerType).getPointerIndirectionLevel() and n > 1
select v, "The variable " + v.getName() + " uses " + n + " levels of pointer indirection."
