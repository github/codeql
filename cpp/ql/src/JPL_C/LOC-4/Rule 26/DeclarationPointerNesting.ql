/**
 * @name Pointer indirection in declaration too high
 * @description The declaration of an object should contain no more than two levels of indirection.
 * @kind problem
 * @id cpp/jpl-c/declaration-pointer-nesting
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jpl
 */

import cpp

string var(Variable v) {
  exists(int level | level = v.getType().getPointerIndirectionLevel() |
    level > 2 and
    result =
      "The type of " + v.getName() + " uses " + level +
        " levels of pointer indirection -- maximum allowed is 2."
  )
}

string fun(Function f) {
  exists(int level | level = f.getType().getPointerIndirectionLevel() |
    level > 2 and
    result =
      "The return type of " + f.getName() + " uses " + level +
        " levels of pointer indirection -- maximum allowed is 2."
  )
}

from Declaration d, string msg
where msg = var(d) or msg = fun(d)
select d, msg
